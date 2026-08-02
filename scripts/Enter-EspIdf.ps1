$ErrorActionPreference = 'Stop'

$idfRoot = 'C:\Espressif\frameworks\esp-idf-v6.0.2'
$idfToolsRoot = 'C:\Espressif\tools'
$exportScript = Join-Path $idfRoot 'export.ps1'

if (-not (Test-Path -LiteralPath $exportScript)) {
    throw "ESP-IDF export script bulunamadı: $exportScript"
}

$env:IDF_TOOLS_PATH = $idfToolsRoot
. $exportScript

Write-Host "ESP-IDF laboratuvar ortamı hazır." -ForegroundColor Green
idf.py --version
