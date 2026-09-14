param(
    [string]$Port = "COM8"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$lab01Build = Join-Path $repoRoot "labs\01-chip-discovery\firmware\build"
$python = "C:\Espressif\tools\python_env\idf6.0_py3.12_env\Scripts\python.exe"
$partitionTool = "C:\Espressif\frameworks\esp-idf-v6.0.2\components\partition_table\gen_esp32part.py"

$bootloaderBuild = Join-Path $lab01Build "bootloader\bootloader.bin"
$partitionBuild = Join-Path $lab01Build "partition_table\partition-table.bin"
$applicationBuild = Join-Path $lab01Build "chip_discovery.bin"

foreach ($requiredFile in @($python, $partitionTool, $bootloaderBuild, $partitionBuild, $applicationBuild)) {
    if (-not (Test-Path -LiteralPath $requiredFile)) {
        throw "Gerekli dosya bulunamadi: $requiredFile"
    }
}

$runId = Get-Date -Format "yyyyMMdd-HHmmss"
$evidenceDirectory = Join-Path $repoRoot "evidence\private\lab02\$runId"
New-Item -ItemType Directory -Path $evidenceDirectory -Force | Out-Null

$bootloaderReadback = Join-Path $evidenceDirectory "bootloader-readback.bin"
$partitionReadback = Join-Path $evidenceDirectory "partition-table-readback.bin"
$applicationReadback = Join-Path $evidenceDirectory "application-readback.bin"
$partitionText = Join-Path $evidenceDirectory "partition-table.txt"
$tamperedPartition = Join-Path $evidenceDirectory "partition-table-tampered.bin"
$tamperedOutput = Join-Path $evidenceDirectory "tampered-parse.txt"

$bootloaderLength = (Get-Item -LiteralPath $bootloaderBuild).Length
$partitionLength = (Get-Item -LiteralPath $partitionBuild).Length
$applicationLength = (Get-Item -LiteralPath $applicationBuild).Length

Write-Host "[1/5] Partition table karttan okunuyor..."
& $python -m esptool --port $Port read-flash 0x8000 $partitionLength $partitionReadback
if ($LASTEXITCODE -ne 0) { throw "Partition table okunamadi." }

& $python $partitionTool $partitionReadback 2>&1 | Tee-Object -FilePath $partitionText
if ($LASTEXITCODE -ne 0) { throw "Partition table ayrıştırılamadı." }

$partitionContents = Get-Content -Raw -LiteralPath $partitionText
if ($partitionContents -notmatch "factory,app,factory,0x10000,1M") {
    throw "Beklenen factory application kaydi bulunamadi. Flash adresleri degismis olabilir."
}

Write-Host "[2/5] Bootloader karttan okunuyor..."
& $python -m esptool --port $Port read-flash 0x0 $bootloaderLength $bootloaderReadback
if ($LASTEXITCODE -ne 0) { throw "Bootloader okunamadi." }

Write-Host "[3/5] Uygulama karttan okunuyor..."
& $python -m esptool --port $Port read-flash 0x10000 $applicationLength $applicationReadback
if ($LASTEXITCODE -ne 0) { throw "Uygulama okunamadi." }

function Compare-BinaryHash {
    param(
        [string]$Name,
        [string]$BuildFile,
        [string]$ReadbackFile
    )

    $buildHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $BuildFile).Hash
    $readbackHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ReadbackFile).Hash

    [pscustomobject]@{
        Name = $Name
        BuildSHA256 = $buildHash
        ReadbackSHA256 = $readbackHash
        Match = ($buildHash -eq $readbackHash)
    }
}

Write-Host "[4/5] SHA-256 degerleri karsilastiriliyor..."
$comparisons = @(
    Compare-BinaryHash -Name "bootloader" -BuildFile $bootloaderBuild -ReadbackFile $bootloaderReadback
    Compare-BinaryHash -Name "partition-table" -BuildFile $partitionBuild -ReadbackFile $partitionReadback
    Compare-BinaryHash -Name "application" -BuildFile $applicationBuild -ReadbackFile $applicationReadback
)

$comparisons | Format-Table -AutoSize
if ($comparisons.Match -contains $false) {
    throw "Karttan okunan dosyalardan en az biri build dosyasiyla eslesmiyor."
}

Write-Host "[5/5] Yalniz yerel partition table kopyasinda negatif test yapiliyor..."
Copy-Item -LiteralPath $partitionReadback -Destination $tamperedPartition -Force
$partitionBytes = [System.IO.File]::ReadAllBytes($tamperedPartition)
$partitionBytes[12] = $partitionBytes[12] -bxor 1
[System.IO.File]::WriteAllBytes($tamperedPartition, $partitionBytes)

$previousErrorPreference = $ErrorActionPreference
$ErrorActionPreference = "Continue"
& $python $partitionTool $tamperedPartition *> $tamperedOutput
$tamperedExitCode = $LASTEXITCODE
$ErrorActionPreference = $previousErrorPreference

$summary = [ordered]@{
    runId = $runId
    port = $Port
    safety = "READ_ONLY_DEVICE_OPERATIONS"
    partitionTableOffset = "0x8000"
    factoryApplicationOffset = "0x10000"
    hashComparisons = $comparisons
    tamperedPartitionParserExitCode = $tamperedExitCode
    tamperedPartitionRejected = ($tamperedExitCode -ne 0)
}

$summary | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $evidenceDirectory "summary.json")

if ($tamperedExitCode -eq 0) {
    throw "Negatif test basarisiz: bozuk partition table reddedilmedi."
}

Write-Host "Lab 02 basarili. Kanit klasoru: $evidenceDirectory"
