# Somente laboratório. Este arquivo é carregado pelos scripts de JML.
# Não execute este arquivo sozinho. Não use em domínio de empresa.

Set-StrictMode -Version 3.0

function Assert-DominioDeLaboratorio {
    <#
    .SYNOPSIS
        Recusa rodar se o domínio atual não for o laboratório previsto.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$DominioEsperado
    )

    if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
        throw 'Módulo ActiveDirectory não encontrado. Instale as RSAT de AD DS no controlador de domínio de laboratório.'
    }

    Import-Module ActiveDirectory -ErrorAction Stop
    $dominio = Get-ADDomain

    if ($dominio.DNSRoot -ne $DominioEsperado) {
        throw @"
Domínio atual '$($dominio.DNSRoot)' é diferente de '$DominioEsperado'.
Este modelo não roda em domínio de empresa.
Se o seu laboratório usa outro nome, altere -DominioEsperado de propósito e leia SEGURANCA.md antes.
"@
    }

    return $dominio
}

function New-ArquivoLogLab {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Prefixo
    )

    $pasta = Join-Path $PSScriptRoot 'logs'
    if (-not (Test-Path -LiteralPath $pasta)) {
        New-Item -ItemType Directory -Path $pasta | Out-Null
    }

    $caminho = Join-Path $pasta ('{0}-{1:yyyyMMdd-HHmmss}.log' -f $Prefixo, (Get-Date))
    New-Item -ItemType File -Path $caminho | Out-Null
    return $caminho
}

function Write-LogLab {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Caminho,
        [Parameter(Mandatory = $true)]
        [string]$Mensagem
    )

    $linha = '{0:yyyy-MM-dd HH:mm:ss} {1}' -f (Get-Date), $Mensagem
    # AppendAllText evita o BOM repetido do Add-Content -Encoding UTF8 no Windows PowerShell 5.1.
    $utf8 = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::AppendAllText($Caminho, ($linha + [Environment]::NewLine), $utf8)
    Write-Host $linha
}

function Get-CampoLab {
    param(
        $Linha,
        [Parameter(Mandatory = $true)]
        [string]$Nome
    )

    $propriedade = $Linha.PSObject.Properties[$Nome]
    if (-not $propriedade -or $null -eq $propriedade.Value) {
        return ''
    }

    return ([string]$propriedade.Value).Trim()
}

function Resolve-OuLaboratorio {
    <#
    .SYNOPSIS
        Monta o DN da OU. "OU=RH" vira "OU=RH,OU=Usuarios,DC=...".
        Um DN que já contém DC= é usado como está.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$OuInformada,
        [Parameter(Mandatory = $true)]
        [string]$SufixoDn
    )

    $ou = $OuInformada.Trim()
    if ($ou -match '(?i)DC=') {
        return $ou
    }

    return ('{0},{1}' -f $ou, $SufixoDn)
}

function Convert-ListaGrupos {
    param(
        [string]$Texto
    )

    $grupos = @()
    if (-not [string]::IsNullOrWhiteSpace($Texto)) {
        $grupos = @(
            $Texto.Split(';') | ForEach-Object { $_.Trim() } | Where-Object { $_ }
        )
    }

    # A vírgula devolve o array inteiro, mesmo quando há zero ou um grupo.
    return ,$grupos
}

function Test-DadoFicticioLab {
    <#
    .SYNOPSIS
        Barra CPF e e-mail de provedor público. Não detecta todo dado real.
    #>
    param(
        [string]$Valor,
        [string]$Campo,
        [string]$Identificador
    )

    if ([string]::IsNullOrWhiteSpace($Valor)) {
        return
    }

    if ($Valor -match '\d{3}\.?\d{3}\.?\d{3}-?\d{2}') {
        throw "Linha $Identificador, campo ${Campo}: o valor parece CPF. Use só identificador fictício."
    }

    if ($Valor -match '(?i)@(gmail|hotmail|outlook|yahoo|live|icloud)\.') {
        throw "Linha $Identificador, campo ${Campo}: e-mail pessoal não entra no laboratório."
    }
}

function Import-CsvLaboratorio {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Caminho,
        [Parameter(Mandatory = $true)]
        [string[]]$ColunasObrigatorias
    )

    if (-not (Test-Path -LiteralPath $Caminho)) {
        throw "CSV não encontrado: $Caminho"
    }

    $linhas = @(Import-Csv -LiteralPath $Caminho -Delimiter ';' -Encoding UTF8)
    if ($linhas.Count -eq 0) {
        throw "CSV sem linhas de dados: $Caminho"
    }

    $presentes = @($linhas[0].PSObject.Properties.Name)
    $faltando = @($ColunasObrigatorias | Where-Object { $presentes -notcontains $_ })
    if ($faltando.Count -gt 0) {
        throw ('CSV sem colunas obrigatórias: {0}' -f ($faltando -join ', '))
    }

    return ,$linhas
}
