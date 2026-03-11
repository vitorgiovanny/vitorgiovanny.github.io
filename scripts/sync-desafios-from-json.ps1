param(
    [string]$Source = "src/Config/data.json",
    [string]$DesafiosDir = "_desafios",
    [string]$DataFile = "_data/desafios.json"
)

$ErrorActionPreference = "Stop"

$projectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$sourcePath = Join-Path $projectRoot $Source
$desafiosPath = Join-Path $projectRoot $DesafiosDir
$dataFilePath = Join-Path $projectRoot $DataFile
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

if (-not (Test-Path $sourcePath)) {
    throw "Arquivo não encontrado: $sourcePath"
}

if (-not (Test-Path $desafiosPath)) {
    New-Item -ItemType Directory -Path $desafiosPath | Out-Null
}

if (-not (Test-Path (Split-Path $dataFilePath -Parent))) {
    New-Item -ItemType Directory -Path (Split-Path $dataFilePath -Parent) | Out-Null
}

function Convert-ToSlug {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) {
        return "desafio"
    }

    $normalized = $Text.Normalize([Text.NormalizationForm]::FormD)
    $builder = New-Object System.Text.StringBuilder

    foreach ($ch in $normalized.ToCharArray()) {
        $category = [Globalization.CharUnicodeInfo]::GetUnicodeCategory($ch)
        if ($category -ne [Globalization.UnicodeCategory]::NonSpacingMark) {
            [void]$builder.Append($ch)
        }
    }

    $withoutAccents = $builder.ToString().Normalize([Text.NormalizationForm]::FormC).ToLowerInvariant()
    $slug = $withoutAccents -replace "[^a-z0-9\s-]", "" -replace "\s+", "-" -replace "-+", "-"
    return $slug.Trim("-")
}

function Normalize-Status {
    param([string]$Status)

    switch ($Status.ToLowerInvariant()) {
        "facil" { return "Facil" }
        "medio" { return "Medio" }
        "dificil" { return "Dificil" }
        default { return $Status }
    }
}

function Convert-ToYamlList {
    param([object[]]$Items)

    if (-not $Items -or $Items.Count -eq 0) {
        return "  - geral"
    }

    return ($Items | ForEach-Object { "  - `"$(Escape-YamlString $_.ToString())`"" }) -join "`n"
}

function Convert-ToYamlBlock {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) {
        return "  <p>Sem requisitos definidos.</p>"
    }

    $prepared = ($Text -replace ">\s+<", ">`n<")
    $lines = $prepared -split "`r?`n"
    return ($lines | ForEach-Object { "  $($_.Trim())" }) -join "`n"
}

function Escape-YamlString {
    param([string]$Text)

    if ($null -eq $Text) {
        return ""
    }

    return $Text.Replace("\", "\\").Replace('"', '\"')
}

$items = Get-Content -Raw -Path $sourcePath -Encoding UTF8 | ConvertFrom-Json
$summary = @()
$generatedFiles = @()

foreach ($item in $items) {
    $title = $item.title
    $slug = Convert-ToSlug $title
    $descriptionTitle = $item.descriptionTitle
    $status = Normalize-Status $item.status
    $tags = @($item.tags)
    $aprendizado = @($item.aprendizado)
    $requisitosHtml = [string]$item.requisitos
    $descriptionHtml = [string]$item.description
    $codeUrl = [string]$item.href

    $tagsYaml = Convert-ToYamlList $tags
    $aprendizadoYaml = Convert-ToYamlList $aprendizado
    $requisitosYaml = Convert-ToYamlBlock $requisitosHtml

    $frontMatter = @"
---
title: "$(Escape-YamlString $title)"
description_title: "$(Escape-YamlString $descriptionTitle)"
status: "$(Escape-YamlString $status)"
tags:
$tagsYaml
code_url: "$(Escape-YamlString $codeUrl)"
aprendizado:
$aprendizadoYaml
requisitos_html: |
$requisitosYaml
---
"@

    if ([string]::IsNullOrWhiteSpace($descriptionHtml)) {
        $descriptionHtml = $descriptionTitle
    }

    $content = "$frontMatter`n`n$descriptionHtml`n"
    $targetFile = Join-Path $desafiosPath "$slug.md"
    [System.IO.File]::WriteAllText($targetFile, $content, $utf8NoBom)
    $generatedFiles += [System.IO.Path]::GetFileName($targetFile)

    $summary += [PSCustomObject]@{
        id = [int]$item.Id
        slug = $slug
        title = $title
        descriptionTitle = $descriptionTitle
        status = $status
        tags = $tags
        aprendizado = $aprendizado
    }
}

$summaryJson = $summary | ConvertTo-Json -Depth 8
[System.IO.File]::WriteAllText($dataFilePath, $summaryJson, $utf8NoBom)

$existingMarkdown = Get-ChildItem -Path $desafiosPath -Filter "*.md" | Select-Object -ExpandProperty Name
$staleFiles = $existingMarkdown | Where-Object { $_ -notin $generatedFiles }

foreach ($file in $staleFiles) {
    Remove-Item -Path (Join-Path $desafiosPath $file) -Force
}

Write-Host "Coleção atualizada com sucesso: $($summary.Count) desafios gerados."
