param(
    [switch]$UsePrivateConfig
)

$ErrorActionPreference = "Stop"

$labsDirectory = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$repoRoot = Split-Path -Parent $labsDirectory
$enterIdf = Join-Path $repoRoot "scripts\Enter-EspIdf.ps1"
$clientDirectory = Join-Path $PSScriptRoot "firmware\ota-client"
$updateDirectory = Join-Path $PSScriptRoot "firmware\untrusted-update"
$privateConfig = Join-Path $clientDirectory ".private\sdkconfig.defaults"

. $enterIdf

Push-Location $updateDirectory
try {
    idf.py set-target esp32c3
    idf.py build
}
finally {
    Pop-Location
}

Push-Location $clientDirectory
try {
    if ($UsePrivateConfig) {
        if (-not (Test-Path -LiteralPath $privateConfig)) {
            throw "Private config bulunamadi. Once Configure-Private.ps1 calistirin."
        }
        idf.py -D "SDKCONFIG_DEFAULTS=sdkconfig.defaults;.private/sdkconfig.defaults" set-target esp32c3
        idf.py -D "SDKCONFIG_DEFAULTS=sdkconfig.defaults;.private/sdkconfig.defaults" build
    }
    else {
        idf.py set-target esp32c3
        idf.py build
    }
}
finally {
    Pop-Location
}

$clientBinary = Join-Path $clientDirectory "build\insecure_ota_client.bin"
$updateBinary = Join-Path $updateDirectory "build\untrusted_update.bin"

Get-Item -LiteralPath $clientBinary, $updateBinary | ForEach-Object {
    [pscustomobject]@{
        File = $_.Name
        Bytes = $_.Length
        SHA256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $_.FullName).Hash
    }
} | Format-Table -AutoSize
