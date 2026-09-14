$ErrorActionPreference = "Stop"

$lab12Directory = Split-Path -Parent $PSScriptRoot
$labsDirectory = Split-Path -Parent $lab12Directory
$repoRoot = Split-Path -Parent $labsDirectory
$python = "C:\Espressif\tools\python_env\idf6.0_py3.12_env\Scripts\python.exe"
$partitionTool = "C:\Espressif\frameworks\esp-idf-v6.0.2\components\partition_table\gen_esp32part.py"
$validCsv = Join-Path $PSScriptRoot "partitions.csv"
$invalidCsv = Join-Path $PSScriptRoot "fixtures\overlapping-partitions.csv"

foreach ($requiredFile in @($python, $partitionTool, $validCsv, $invalidCsv)) {
    if (-not (Test-Path -LiteralPath $requiredFile)) {
        throw "Gerekli dosya bulunamadi: $requiredFile"
    }
}

$runId = Get-Date -Format "yyyyMMdd-HHmmss"
$evidenceDirectory = Join-Path $repoRoot "evidence\private\lab12\00-ota-partition-map\$runId"
New-Item -ItemType Directory -Path $evidenceDirectory -Force | Out-Null

$partitionBinary = Join-Path $evidenceDirectory "partition-table.bin"
$parsedTable = Join-Path $evidenceDirectory "partition-table-parsed.txt"
$invalidBinary = Join-Path $evidenceDirectory "invalid-partition-table.bin"
$invalidOutput = Join-Path $evidenceDirectory "invalid-table-output.txt"

Write-Host "[1/3] Gecerli OTA partition table uretiliyor..."
& $python $partitionTool --flash-size 4MB $validCsv $partitionBinary
if ($LASTEXITCODE -ne 0) { throw "Gecerli partition table uretilemedi." }

Write-Host "[2/3] Binary tablo tekrar okunarak adresler dogrulaniyor..."
& $python $partitionTool $partitionBinary 2>&1 | Tee-Object -FilePath $parsedTable
if ($LASTEXITCODE -ne 0) { throw "Binary partition table ayrıştırılamadı." }

$parsedContents = Get-Content -Raw -LiteralPath $parsedTable
$expectedRows = @(
    "otadata,data,ota,0xf000,8K",
    "ota_0,app,ota_0,0x20000,1536K",
    "ota_1,app,ota_1,0x1a0000,1536K"
)
foreach ($expectedRow in $expectedRows) {
    if ($parsedContents -notmatch [regex]::Escape($expectedRow)) {
        throw "Beklenen partition satiri bulunamadi: $expectedRow"
    }
}

Write-Host "[3/3] Bilerek cakisan partition table negatif testi calistiriliyor..."
$previousErrorPreference = $ErrorActionPreference
$ErrorActionPreference = "Continue"
& $python $partitionTool --flash-size 4MB $invalidCsv $invalidBinary *> $invalidOutput
$invalidExitCode = $LASTEXITCODE
$ErrorActionPreference = $previousErrorPreference

if ($invalidExitCode -eq 0) {
    throw "Negatif test basarisiz: cakisan partition'lar kabul edildi."
}

$flashSizeBytes = 4MB
$usedUntilBytes = 0x320000
$summary = [ordered]@{
    runId = $runId
    evidenceLevel = "HOST_VERIFIED"
    hardwareTouched = $false
    flashSizeBytes = $flashSizeBytes
    usedUntilBytes = $usedUntilBytes
    freeBytesAfterLastPartition = $flashSizeBytes - $usedUntilBytes
    otaSlotBytes = 0x180000
    validTableSHA256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $partitionBinary).Hash
    overlappingTableExitCode = $invalidExitCode
    overlappingTableRejected = $true
}
$summary | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $evidenceDirectory "summary.json")

Write-Host "Lab 12.00 basarili. Kanit klasoru: $evidenceDirectory"
