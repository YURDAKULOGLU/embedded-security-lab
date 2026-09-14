param(
    [int]$Port = 8070
)

$ErrorActionPreference = "Stop"

$updateBuildDirectory = Join-Path $PSScriptRoot "firmware\untrusted-update\build"
$updateBinary = Join-Path $updateBuildDirectory "untrusted_update.bin"

if (-not (Test-Path -LiteralPath $updateBinary)) {
    throw "Update image bulunamadi. Once .\Build-Lab.ps1 calistirin."
}

$hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $updateBinary).Hash
Write-Host "Bilerek guvenilmeyen OTA image'i sunuluyor."
Write-Host "Dosya : $updateBinary"
Write-Host "SHA256: $hash"
Write-Host "URL    : http://<BU-BILGISAYARIN-IP-ADRESI>:$Port/untrusted_update.bin"
Write-Host "Sunucuyu durdurmak icin Ctrl+C kullanin."

python -m http.server $Port --bind 0.0.0.0 --directory $updateBuildDirectory
