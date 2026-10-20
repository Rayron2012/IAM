#Requires -Version 5.1
#Requires -Modules ActiveDirectory
<#
.SYNOPSIS
    Joiner de laboratório: cria usuários fictícios a partir de um CSV.

.DESCRIPTION
    SOMENTE LABORATÓRIO. Domínio previsto: labiam.local, depois de um snapshot.
    A senha inicial é pedida na hora, não fica no CSV e não é escrita no log.
    Cada conta nasce com troca de senha no próximo logon.
    Usuário que já existe não é alterado.
    Rode antes .\Prepara-EstruturaLab.ps1 e sempre a primeira vez com -WhatIf.

.EXAMPLE
    .\Novo-UsuariosLab.ps1 -CaminhoCsv .\usuarios-joiner.csv -WhatIf

.EXAMPLE
    .\Novo-UsuariosLab.ps1 -CaminhoCsv .\usuarios-joiner.csv
#>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [Parameter(Mandatory = $true)]
    [string]$CaminhoCsv,

    [string]$DominioEsperado = 'labiam.local',

    [securestring]$SenhaInicial
)

$comum = Join-Path $PSScriptRoot 'LabComum.ps1'
if (-not (Test-Path -LiteralPath $comum)) {
    throw "Arquivo não encontrado: $comum"
}
. $comum

$dominio = Assert-DominioDeLaboratorio -DominioEsperado $DominioEsperado
$sufixoOu = 'OU=Usuarios,{0}' -f $dominio.DistinguishedName
$sufixoUpn = '@{0}' -f $dominio.DNSRoot
$log = New-ArquivoLogLab -Prefixo 'joiner'
$colunas = @('SamAccountName', 'Nome', 'Sobrenome', 'Departamento', 'Cargo', 'OU', 'Grupos', 'Matricula', 'Chamado')
$linhas = Import-CsvLaboratorio -Caminho $CaminhoCsv -ColunasObrigatorias $colunas

if (-not $WhatIfPreference -and -not $SenhaInicial) {
    $SenhaInicial = Read-Host 'Senha inicial do laboratório (não será gravada)' -AsSecureString
}

Write-LogLab -Caminho $log -Mensagem ("Joiner: {0} linha(s) em {1}." -f $linhas.Count, $CaminhoCsv)
$falhas = 0

foreach ($linha in $linhas) {
    $sam = Get-CampoLab -Linha $linha -Nome 'SamAccountName'
    $nome = Get-CampoLab -Linha $linha -Nome 'Nome'
    $sobrenome = Get-CampoLab -Linha $linha -Nome 'Sobrenome'
    $departamento = Get-CampoLab -Linha $linha -Nome 'Departamento'
    $cargo = Get-CampoLab -Linha $linha -Nome 'Cargo'
    $ouCurta = Get-CampoLab -Linha $linha -Nome 'OU'
    $gruposTexto = Get-CampoLab -Linha $linha -Nome 'Grupos'
    $matricula = Get-CampoLab -Linha $linha -Nome 'Matricula'
    $chamado = Get-CampoLab -Linha $linha -Nome 'Chamado'

    if (-not $sam) {
        continue
    }

    try {
        foreach ($campo in @($sam, $nome, $sobrenome, $departamento, $cargo, $matricula, $chamado)) {
            Test-DadoFicticioLab -Valor $campo -Campo 'csv' -Identificador $sam
        }

        if ($sam -notmatch '^[A-Za-z][A-Za-z0-9.\-]{1,19}$') {
            throw 'SamAccountName fora do padrão do laboratório (letra, número, ponto, hífen, até 20).'
        }
        if (-not $nome -or -not $sobrenome -or -not $ouCurta -or -not $matricula -or -not $chamado) {
            throw 'Preencha Nome, Sobrenome, OU, Matricula e Chamado.'
        }
        if ($matricula -notmatch '^\d{4}$') {
            throw 'Matrícula fictícia deve ter 4 dígitos (exemplo: 1001), nunca CPF.'
        }

        $existente = Get-ADUser -Filter "SamAccountName -eq '$sam'" -ErrorAction SilentlyContinue
        if ($existente) {
            Write-LogLab -Caminho $log -Mensagem "IGNORADO $sam já existe. Este joiner não altera conta existente."
            continue
        }

        $ou = Resolve-OuLaboratorio -OuInformada $ouCurta -SufixoDn $sufixoOu
        $null = Get-ADOrganizationalUnit -Identity $ou -ErrorAction Stop
        $nomeExibicao = '{0} {1}' -f $nome, $sobrenome
        $upn = '{0}{1}' -f $sam, $sufixoUpn
        $descricao = 'LAB | joiner | chamado {0} | {1:yyyy-MM-dd}' -f $chamado, (Get-Date)
        $grupos = Convert-ListaGrupos -Texto $gruposTexto

        foreach ($grupo in $grupos) {
            $achado = Get-ADGroup -Filter "SamAccountName -eq '$grupo'" -ErrorAction SilentlyContinue
            if (-not $achado) {
                throw "Grupo inexistente: $grupo. Rode Prepara-EstruturaLab.ps1 antes."
            }
        }

        if ($PSCmdlet.ShouldProcess($sam, "Criar usuário em $ou")) {
            New-ADUser `
                -Name $nomeExibicao `
                -DisplayName $nomeExibicao `
                -GivenName $nome `
                -Surname $sobrenome `
                -SamAccountName $sam `
                -UserPrincipalName $upn `
                -EmailAddress $upn `
                -Department $departamento `
                -Title $cargo `
                -Company 'LabIAM' `
                -EmployeeID $matricula `
                -Description $descricao `
                -Path $ou `
                -AccountPassword $SenhaInicial `
                -ChangePasswordAtLogon $true `
                -Enabled $true `
                -ErrorAction Stop

            foreach ($grupo in $grupos) {
                Add-ADGroupMember -Identity $grupo -Members $sam -ErrorAction Stop
            }

            Write-LogLab -Caminho $log -Mensagem ("CRIADO {0} em {1}; grupos: {2}; chamado {3}" -f $sam, $ou, ($(if ($grupos) { $grupos -join ';' } else { '(nenhum)' })), $chamado)
        }
        else {
            Write-LogLab -Caminho $log -Mensagem ("WHATIF criaria {0} em {1}; grupos: {2}" -f $sam, $ou, ($(if ($grupos) { $grupos -join ';' } else { '(nenhum)' })))
        }
    }
    catch {
        $falhas++
        Write-LogLab -Caminho $log -Mensagem ("FALHA {0}: {1}" -f $sam, $_.Exception.Message)
    }
}

Write-LogLab -Caminho $log -Mensagem ("Fim do joiner. Falhas: {0}. Log: {1}" -f $falhas, $log)
if ($falhas -gt 0) {
    exit 1
}
