$ErrorActionPreference = "Stop"

$clientDirectory = Join-Path $PSScriptRoot "firmware\ota-client"
$privateDirectory = Join-Path $clientDirectory ".private"
$privateConfig = Join-Path $privateDirectory "sdkconfig.defaults"

$wifiSsid = Read-Host "Lab Wi-Fi SSID"
$securePassword = Read-Host "Lab Wi-Fi password" -AsSecureString
$serverIp = Read-Host "Bu bilgisayarin ESP32-C3 tarafindan erisilebilen IPv4 adresi"

$passwordPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
try {
    $wifiPassword = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($passwordPointer)

    function Convert-ToKconfigString([string]$value) {
        return $value.Replace("\", "\\").Replace('"', '\"')
    }

    New-Item -ItemType Directory -Path $privateDirectory -Force | Out-Null
    $settings = @(
        ('CONFIG_EXAMPLE_WIFI_SSID="{0}"' -f (Convert-ToKconfigString $wifiSsid))
        ('CONFIG_EXAMPLE_WIFI_PASSWORD="{0}"' -f (Convert-ToKconfigString $wifiPassword))
        ('CONFIG_LAB_OTA_URL="http://{0}:8070/untrusted_update.bin"' -f (Convert-ToKconfigString $serverIp))
    )
    Set-Content -LiteralPath $privateConfig -Value $settings
}
finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($passwordPointer)
}

Write-Host "Private lab ayarlari Git tarafindan yok sayilan dosyaya yazildi: $privateConfig"
