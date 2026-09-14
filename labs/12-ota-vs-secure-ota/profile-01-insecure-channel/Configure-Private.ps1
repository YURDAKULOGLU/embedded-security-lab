param(
    [string]$WifiSsid,
    [securestring]$WifiPassword,
    [string]$ServerIp
)

$ErrorActionPreference = "Stop"

$clientDirectory = Join-Path $PSScriptRoot "firmware\ota-client"
$privateDirectory = Join-Path $clientDirectory ".private"
$privateConfig = Join-Path $privateDirectory "sdkconfig.defaults"

if (-not $PSBoundParameters.ContainsKey("WifiSsid")) {
    $WifiSsid = Read-Host "Lab Wi-Fi SSID"
}
if (-not $PSBoundParameters.ContainsKey("WifiPassword")) {
    $WifiPassword = Read-Host "Lab Wi-Fi password" -AsSecureString
}
if (-not $PSBoundParameters.ContainsKey("ServerIp")) {
    $ServerIp = Read-Host "Bu bilgisayarin ESP32-C3 tarafindan erisilebilen IPv4 adresi"
}

$passwordPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($WifiPassword)
try {
    $plainWifiPassword = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($passwordPointer)

    function Convert-ToKconfigString([string]$value) {
        return $value.Replace("\", "\\").Replace('"', '\"')
    }

    New-Item -ItemType Directory -Path $privateDirectory -Force | Out-Null
    $settings = @(
        ('CONFIG_EXAMPLE_WIFI_SSID="{0}"' -f (Convert-ToKconfigString $WifiSsid))
        ('CONFIG_EXAMPLE_WIFI_PASSWORD="{0}"' -f (Convert-ToKconfigString $plainWifiPassword))
        ('CONFIG_LAB_OTA_URL="http://{0}:8070/untrusted_update.bin"' -f (Convert-ToKconfigString $ServerIp))
    )
    [IO.File]::WriteAllLines($privateConfig, $settings, [Text.UTF8Encoding]::new($false))
}
finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($passwordPointer)
}

Write-Host "Private lab ayarlari Git tarafindan yok sayilan dosyaya yazildi: $privateConfig"
