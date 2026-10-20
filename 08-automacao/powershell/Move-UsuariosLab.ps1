#Requires -Version 5.1
#Requires -Modules ActiveDirectory
<#
.SYNOPSIS
    Mover de laboratório: tira os grupos antigos, dá os novos e move a OU.

.DESCRIPTION
    SOMENTE LABORATÓRIO. A ordem é a do JML: remover o acesso antigo antes de
    conceder o novo, e só então mover a conta de OU.
    Não remove o grupo primário (ele não aparece em MemberOf).
    Rode a primeira vez com -WhatIf, depois de um snapshot.

.EXAMPLE
    .\Move-UsuariosLab.ps1 -CaminhoCsv .\usuarios-mover.csv -WhatIf
#>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [Parameter(Mandatory = $true)]
    [string]$CaminhoCsv,

    [string]$DominioEsperado = 'labiam.local'
)

$comum = Join-Path $PSScriptRoot 'LabComum.ps1'
if (-not (Test-Path -LiteralPath $comum)) {
    throw "Arquivo não encontrado: $comum"
}
. $comum

$dominio = Assert-DominioDeLaboratorio -DominioEsperado $DominioEsperado
$sufixoOu = 'OU=Usuarios,{0}' -f $dominio.DistinguishedName
$log = New-ArquivoLogLab -Prefixo 'mover'
$colunas = @('SamAccountName', 'OUDestino', 'GruposRemover', 'GruposAdicionar', 'Chamado')
$linhas = Import-CsvLaboratorio -Caminho $CaminhoCsv -ColunasObrigatorias $colunas
Write-LogLab -Caminho $log -Mensagem ("Mover: {0} linha(s)." -f $linhas.Count)
$falhas = 0

foreach ($linha in $linhas) {
    $sam = Get-CampoLab -Linha $linha -Nome 'SamAccountName'
    $ouCurta = Get-CampoLab -Linha $linha -Nome 'OUDestino'
    $remover = Convert-ListaGrupos -Texto (Get-CampoLab -Linha $linha -Nome 'GruposRemover')
    $adicionar = Convert-ListaGrupos -Texto (Get-CampoLab -Linha $linha -Nome 'GruposAdicionar')
    $chamado = Get-CampoLab -Linha $linha -Nome 'Chamado'

    if (-not $sam) {
        continue
    }

    try {
        if ($sam -notmatch '^[A-Za-z][A-Za-z0-9.\-]{1,19}$') {
            throw 'SamAccountName fora do padrão do laboratório.'
        }
        Test-DadoFicticioLab -Valor $sam -Campo 'SamAccountName' -Identificador $sam
        Test-DadoFicticioLab -Valor $chamado -Campo 'Chamado' -Identificador $sam
        if (-not $ouCurta -or -not $chamado) {
            throw 'Preencha OUDestino e Chamado.'
        }

        $usuario = Get-ADUser -Filter "SamAccountName -eq '$sam'" -Properties MemberOf, Description -ErrorAction SilentlyContinue
        if (-not $usuario) {
            throw 'Usuário não existe neste domínio de laboratório.'
        }

        $ou = Resolve-OuLaboratorio -OuInformada $ouCurta -SufixoDn $sufixoOu
        $null = Get-ADOrganizationalUnit -Identity $ou -ErrorAction Stop
        $membrosAtuais = @($usuario.MemberOf | Where-Object { $_ })

        foreach ($grupo in ($remover + $adicionar)) {
            $achado = Get-ADGroup -Filter "SamAccountName -eq '$grupo'" -ErrorAction SilentlyContinue
            if (-not $achado) {
                throw "Grupo inexistente: $grupo"
            }
        }

        if ($PSCmdlet.ShouldProcess($sam, "Mover para $ou e ajustar grupos. Chamado $chamado")) {
            foreach ($grupo in $remover) {
                $dnGrupo = (Get-ADGroup -Identity $grupo).DistinguishedName
                if ($membrosAtuais -notcontains $dnGrupo) {
                    Write-LogLab -Caminho $log -Mensagem "AVISO $sam não era membro de $grupo. Nada removido."
                    continue
                }
                Remove-ADGroupMember -Identity $grupo -Members $sam -Confirm:$false -ErrorAction Stop
                Write-LogLab -Caminho $log -Mensagem "REMOVIDO $sam de $grupo"
            }

            foreach ($grupo in $adicionar) {
                Add-ADGroupMember -Identity $grupo -Members $sam -ErrorAction Stop
                Write-LogLab -Caminho $log -Mensagem "ADICIONADO $sam em $grupo"
            }

            if ($usuario.DistinguishedName -notlike "*,$ou") {
                Move-ADObject -Identity $usuario.DistinguishedName -TargetPath $ou -ErrorAction Stop
                Write-LogLab -Caminho $log -Mensagem "MOVIDO $sam para $ou"
            }
            else {
                Write-LogLab -Caminho $log -Mensagem "OU já é a de destino: $sam"
            }

            $descricao = 'LAB | mover | chamado {0} | {1:yyyy-MM-dd}' -f $chamado, (Get-Date)
            Set-ADUser -Identity $sam -Description $descricao -ErrorAction Stop
        }
        else {
            Write-LogLab -Caminho $log -Mensagem ("WHATIF {0}: remover [{1}]; adicionar [{2}]; OU {3}" -f $sam, ($remover -join ';'), ($adicionar -join ';'), $ou)
        }
    }
    catch {
        $falhas++
        Write-LogLab -Caminho $log -Mensagem ("FALHA {0}: {1}" -f $sam, $_.Exception.Message)
    }
}

Write-LogLab -Caminho $log -Mensagem ("Fim do mover. Falhas: {0}. Log: {1}" -f $falhas, $log)
if ($falhas -gt 0) {
    exit 1
}
