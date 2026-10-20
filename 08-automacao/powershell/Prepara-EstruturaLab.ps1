#Requires -Version 5.1
#Requires -Modules ActiveDirectory
<#
.SYNOPSIS
    Cria a estrutura de OUs e grupos do domínio de laboratório LabIAM.

.DESCRIPTION
    SOMENTE LABORATÓRIO. Teste numa VM isolada, com snapshot, no domínio labiam.local.
    Não cria usuários. Não delega permissão (isso continua no assistente do dsa.msc).
    Pode ser executado de novo: o que já existe é mantido.

.EXAMPLE
    .\Prepara-EstruturaLab.ps1 -WhatIf

.EXAMPLE
    .\Prepara-EstruturaLab.ps1
#>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [string]$DominioEsperado = 'labiam.local'
)

$comum = Join-Path $PSScriptRoot 'LabComum.ps1'
if (-not (Test-Path -LiteralPath $comum)) {
    throw "Arquivo não encontrado: $comum"
}
. $comum

$dominio = Assert-DominioDeLaboratorio -DominioEsperado $DominioEsperado
$dn = $dominio.DistinguishedName
$log = New-ArquivoLogLab -Prefixo 'prepara'
Write-LogLab -Caminho $log -Mensagem "Início da estrutura no domínio $($dominio.DNSRoot)."

$ous = @(
    @{ Nome = 'Usuarios'; Path = $dn },
    @{ Nome = 'Grupos'; Path = $dn },
    @{ Nome = 'Computadores'; Path = $dn },
    @{ Nome = 'ContasServico'; Path = $dn },
    @{ Nome = 'RH'; Path = ('OU=Usuarios,{0}' -f $dn) },
    @{ Nome = 'Financeiro'; Path = ('OU=Usuarios,{0}' -f $dn) },
    @{ Nome = 'TI'; Path = ('OU=Usuarios,{0}' -f $dn) },
    @{ Nome = 'Comercial'; Path = ('OU=Usuarios,{0}' -f $dn) },
    @{ Nome = 'Desligados'; Path = ('OU=Usuarios,{0}' -f $dn) }
)

foreach ($ou in $ous) {
    $alvo = 'OU={0},{1}' -f $ou.Nome, $ou.Path
    $jaExiste = $false
    try {
        $null = Get-ADOrganizationalUnit -Identity $alvo -ErrorAction Stop
        $jaExiste = $true
    }
    catch {
        $jaExiste = $false
    }

    if ($jaExiste) {
        Write-LogLab -Caminho $log -Mensagem "OU já existe: $alvo"
        continue
    }

    if ($PSCmdlet.ShouldProcess($alvo, 'Criar OU')) {
        New-ADOrganizationalUnit -Name $ou.Nome -Path $ou.Path -ProtectedFromAccidentalDeletion $true -ErrorAction Stop
        Write-LogLab -Caminho $log -Mensagem "OU criada: $alvo"
    }
    else {
        Write-LogLab -Caminho $log -Mensagem "WHATIF criaria OU: $alvo"
    }
}

$ouGrupos = 'OU=Grupos,{0}' -f $dn
$grupos = @(
    @{ Nome = 'GG-RH-Analistas'; Escopo = 'Global'; Notas = 'LabIAM. Papel de negócio do RH. Contas entram aqui.' },
    @{ Nome = 'GG-Financeiro'; Escopo = 'Global'; Notas = 'LabIAM. Papel de negócio do Financeiro.' },
    @{ Nome = 'GG-TI-Suporte'; Escopo = 'Global'; Notas = 'LabIAM. Papel de negócio do suporte.' },
    @{ Nome = 'GG-COM-Vendas'; Escopo = 'Global'; Notas = 'LabIAM. Papel de negócio do Comercial.' },
    @{ Nome = 'GG-Suporte-RH'; Escopo = 'Global'; Notas = 'LabIAM. Exercício de delegação de reset de senha. Deixe vazio até lá.' },
    @{ Nome = 'GG-Admins-TI'; Escopo = 'Global'; Notas = 'LabIAM. Alvo da FGPP. Não coloque conta do dia a dia aqui.' },
    @{ Nome = 'DL-RH-Leitura'; Escopo = 'DomainLocal'; Notas = 'LabIAM. Permissão de leitura no recurso de RH.' },
    @{ Nome = 'DL-FIN-Leitura'; Escopo = 'DomainLocal'; Notas = 'LabIAM. Permissao de leitura na pasta do Financeiro. Nome curto: sAMAccountName tem limite de 20 caracteres.' }
)

foreach ($grupo in $grupos) {
    $nome = $grupo.Nome
    $existente = Get-ADGroup -Filter "SamAccountName -eq '$nome'" -ErrorAction SilentlyContinue
    if ($existente) {
        Write-LogLab -Caminho $log -Mensagem "Grupo já existe: $nome"
        continue
    }

    if ($PSCmdlet.ShouldProcess($nome, ('Criar grupo {0}' -f $grupo.Escopo))) {
        New-ADGroup -Name $nome -SamAccountName $nome -GroupScope $grupo.Escopo -GroupCategory Security -Path $ouGrupos -Description $grupo.Notas -ErrorAction Stop
        Write-LogLab -Caminho $log -Mensagem "Grupo criado: $nome ($($grupo.Escopo))."
    }
    else {
        Write-LogLab -Caminho $log -Mensagem "WHATIF criaria grupo: $nome ($($grupo.Escopo))"
    }
}

$aninhar = @(
    @{ Pai = 'DL-RH-Leitura'; Membro = 'GG-RH-Analistas' },
    @{ Pai = 'DL-FIN-Leitura'; Membro = 'GG-Financeiro' }
)

foreach ($par in $aninhar) {
    $pai = Get-ADGroup -Filter "SamAccountName -eq '$($par.Pai)'" -ErrorAction SilentlyContinue
    $membro = Get-ADGroup -Filter "SamAccountName -eq '$($par.Membro)'" -ErrorAction SilentlyContinue
    if (-not $pai -or -not $membro) {
        Write-LogLab -Caminho $log -Mensagem "Pendente: não aninhei $($par.Membro) em $($par.Pai) porque um dos grupos ainda não existe (normal com -WhatIf)."
        continue
    }

    $membros = @(Get-ADGroupMember -Identity $par.Pai -ErrorAction SilentlyContinue | Select-Object -ExpandProperty SamAccountName)
    if ($membros -contains $par.Membro) {
        Write-LogLab -Caminho $log -Mensagem "Aninhamento já existe: $($par.Membro) -> $($par.Pai)"
        continue
    }

    if ($PSCmdlet.ShouldProcess($par.Pai, ('Adicionar {0}' -f $par.Membro))) {
        Add-ADGroupMember -Identity $par.Pai -Members $par.Membro -ErrorAction Stop
        Write-LogLab -Caminho $log -Mensagem "AGDLP: $($par.Membro) entrou em $($par.Pai)"
    }
    else {
        Write-LogLab -Caminho $log -Mensagem "WHATIF aninharia $($par.Membro) em $($par.Pai)"
    }
}

Write-LogLab -Caminho $log -Mensagem 'Fim. Delegação, GPO, pasta compartilhada e FGPP continuam manuais, no checklist da fase 2.'
Write-LogLab -Caminho $log -Mensagem "Log: $log"
