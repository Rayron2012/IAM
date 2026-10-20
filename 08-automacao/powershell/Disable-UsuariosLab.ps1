#Requires -Version 5.1
#Requires -Modules ActiveDirectory
<#
.SYNOPSIS
    Leaver de laboratório: desabilita, tira os grupos e move para a OU de desligados.

.DESCRIPTION
    SOMENTE LABORATÓRIO. Não exclui a conta. A exclusão fica para depois do prazo
    de retenção, fora deste script.
    A senha é trocada por um valor aleatório que não é exibido nem gravado no log.
    O grupo primário permanece, porque o AD não deixa removê-lo por MemberOf.
    Rode a primeira vez com -WhatIf, depois de um snapshot.

.EXAMPLE
    .\Disable-UsuariosLab.ps1 -CaminhoCsv .\usuarios-leaver.csv -WhatIf
#>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [Parameter(Mandatory = $true)]
    [string]$CaminhoCsv,

    [string]$DominioEsperado = 'labiam.local',

    [string]$OuDesligados = 'OU=Desligados'
)

$comum = Join-Path $PSScriptRoot 'LabComum.ps1'
if (-not (Test-Path -LiteralPath $comum)) {
    throw "Arquivo não encontrado: $comum"
}
. $comum

function New-SenhaDescartavel {
    # Senha só para invalidar a antiga. A conta será desabilitada e o valor não sai da memória.
    $alfabeto = 'abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789!@#'.ToCharArray()
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    try {
        $bytes = New-Object byte[] 32
        $rng.GetBytes($bytes)
        $chars = foreach ($byte in $bytes) { $alfabeto[$byte % $alfabeto.Length] }
        $texto = -join $chars
        return (ConvertTo-SecureString -String $texto -AsPlainText -Force)
    }
    finally {
        $rng.Dispose()
    }
}

$dominio = Assert-DominioDeLaboratorio -DominioEsperado $DominioEsperado
$sufixoOu = 'OU=Usuarios,{0}' -f $dominio.DistinguishedName
$ouAlvo = Resolve-OuLaboratorio -OuInformada $OuDesligados -SufixoDn $sufixoOu
$null = Get-ADOrganizationalUnit -Identity $ouAlvo -ErrorAction Stop

$log = New-ArquivoLogLab -Prefixo 'leaver'
$colunas = @('SamAccountName', 'Chamado')
$linhas = Import-CsvLaboratorio -Caminho $CaminhoCsv -ColunasObrigatorias $colunas
Write-LogLab -Caminho $log -Mensagem ("Leaver: {0} linha(s). OU de destino: {1}" -f $linhas.Count, $ouAlvo)
$falhas = 0

foreach ($linha in $linhas) {
    $sam = Get-CampoLab -Linha $linha -Nome 'SamAccountName'
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
        if (-not $chamado) {
            throw 'Informe o chamado fictício.'
        }

        $usuario = Get-ADUser -Filter "SamAccountName -eq '$sam'" -Properties MemberOf, Enabled -ErrorAction SilentlyContinue
        if (-not $usuario) {
            throw 'Usuário não existe neste domínio de laboratório.'
        }

        $grupos = @($usuario.MemberOf | Where-Object { $_ })
        if ($PSCmdlet.ShouldProcess($sam, "Desabilitar, remover grupos e mover para $ouAlvo. Chamado $chamado")) {
            # Desabilita primeiro para a conta deixar de autenticar enquanto o resto acontece.
            if ($usuario.Enabled) {
                Disable-ADAccount -Identity $sam -ErrorAction Stop
                Write-LogLab -Caminho $log -Mensagem "DESABILITADO $sam"
            }
            else {
                Write-LogLab -Caminho $log -Mensagem "JÁ DESABILITADO $sam"
            }

            $senha = New-SenhaDescartavel
            Set-ADAccountPassword -Identity $sam -Reset -NewPassword $senha -ErrorAction Stop
            Write-LogLab -Caminho $log -Mensagem "SENHA RESETADA $sam (valor não registrado)"

            foreach ($dnGrupo in $grupos) {
                $nomeGrupo = (Get-ADGroup -Identity $dnGrupo).SamAccountName
                Remove-ADGroupMember -Identity $dnGrupo -Members $sam -Confirm:$false -ErrorAction Stop
                Write-LogLab -Caminho $log -Mensagem "REMOVIDO $sam de $nomeGrupo"
            }

            $descricao = 'LAB | leaver | chamado {0} | {1:yyyy-MM-dd} | retencao pendente, nao excluir' -f $chamado, (Get-Date)
            Set-ADUser -Identity $sam -Description $descricao -ErrorAction Stop

            if ($usuario.DistinguishedName -notlike "*,$ouAlvo") {
                Move-ADObject -Identity $usuario.DistinguishedName -TargetPath $ouAlvo -ErrorAction Stop
                Write-LogLab -Caminho $log -Mensagem "MOVIDO $sam para $ouAlvo"
            }
            else {
                Write-LogLab -Caminho $log -Mensagem "JÁ NA OU DE DESLIGADOS $sam"
            }
        }
        else {
            $nomes = @()
            foreach ($dnGrupo in $grupos) {
                $nomes += (Get-ADGroup -Identity $dnGrupo).SamAccountName
            }
            $lista = if ($nomes.Count -gt 0) { $nomes -join ';' } else { '(nenhum grupo extra)' }
            Write-LogLab -Caminho $log -Mensagem "WHATIF desabilitaria $sam, removeria [$lista] e moveria para $ouAlvo"
        }
    }
    catch {
        $falhas++
        Write-LogLab -Caminho $log -Mensagem ("FALHA {0}: {1}" -f $sam, $_.Exception.Message)
    }
}

Write-LogLab -Caminho $log -Mensagem ("Fim do leaver. Falhas: {0}. Log: {1}" -f $falhas, $log)
Write-LogLab -Caminho $log -Mensagem 'A conta não foi excluída. Exclusão só depois do prazo de retenção, com evidência.'
if ($falhas -gt 0) {
    exit 1
}
