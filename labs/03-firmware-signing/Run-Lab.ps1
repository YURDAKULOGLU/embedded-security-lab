param(
    [string]$SourceBinary = ""
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
if ([string]::IsNullOrWhiteSpace($SourceBinary)) {
    $SourceBinary = Join-Path $repoRoot 'labs\01-chip-discovery\firmware\build\chip_discovery.bin'
}
$SourceBinary = (Resolve-Path -LiteralPath $SourceBinary).Path

$espsecure = Get-Command espsecure -ErrorAction Stop
$runId = Get-Date -Format 'yyyyMMdd-HHmmss'
$runDirectory = Join-Path $repoRoot "evidence\private\lab03\$runId"
New-Item -ItemType Directory -Path $runDirectory -Force | Out-Null

$signingKey = Join-Path $runDirectory 'signing-key.pem'
$publicKey = Join-Path $runDirectory 'signing-public-key.bin'
$wrongKey = Join-Path $runDirectory 'wrong-key.pem'
$wrongPublicKey = Join-Path $runDirectory 'wrong-public-key.bin'
$unsignedImage = Join-Path $runDirectory 'unsigned.bin'
$signedImage = Join-Path $runDirectory 'signed.bin'
$tamperedImage = Join-Path $runDirectory 'tampered.bin'

Copy-Item -LiteralPath $SourceBinary -Destination $unsignedImage

& $espsecure.Source generate-signing-key --version 2 $signingKey
& $espsecure.Source extract-public-key --version 2 --keyfile $signingKey $publicKey
& $espsecure.Source generate-signing-key --version 2 $wrongKey
& $espsecure.Source extract-public-key --version 2 --keyfile $wrongKey $wrongPublicKey
& $espsecure.Source sign-data --version 2 --keyfile $signingKey --output $signedImage $unsignedImage

$signedBytes = [System.IO.File]::ReadAllBytes($signedImage)
$tamperOffset = 100
$signedBytes[$tamperOffset] = $signedBytes[$tamperOffset] -bxor 0x01
[System.IO.File]::WriteAllBytes($tamperedImage, $signedBytes)

$goodOutput = (& $espsecure.Source verify-signature --version 2 --keyfile $publicKey $signedImage 2>&1 | Out-String).Trim()
$goodExitCode = $LASTEXITCODE
$tamperedOutput = (& $espsecure.Source verify-signature --version 2 --keyfile $publicKey $tamperedImage 2>&1 | Out-String).Trim()
$tamperedExitCode = $LASTEXITCODE
$wrongKeyOutput = (& $espsecure.Source verify-signature --version 2 --keyfile $wrongPublicKey $signedImage 2>&1 | Out-String).Trim()
$wrongKeyExitCode = $LASTEXITCODE
$signatureInfo = (& $espsecure.Source signature-info-v2 $signedImage 2>&1 | Out-String).Trim()

$summary = [ordered]@{
    run_id = $runId
    source_file = [System.IO.Path]::GetFileName($SourceBinary)
    scheme = 'Secure Boot V2 / RSA-3072 / RSA-PSS / SHA-256'
    tamper_offset = $tamperOffset
    unsigned_sha256 = (Get-FileHash -LiteralPath $unsignedImage -Algorithm SHA256).Hash
    signed_sha256 = (Get-FileHash -LiteralPath $signedImage -Algorithm SHA256).Hash
    tampered_sha256 = (Get-FileHash -LiteralPath $tamperedImage -Algorithm SHA256).Hash
    good_verification_exit_code = $goodExitCode
    tampered_verification_exit_code = $tamperedExitCode
    wrong_key_verification_exit_code = $wrongKeyExitCode
    good_verification_output = $goodOutput
    tampered_verification_output = $tamperedOutput
    wrong_key_verification_output = $wrongKeyOutput
    signature_info = $signatureInfo
}

$summaryPath = Join-Path $runDirectory 'summary.json'
$summary | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $summaryPath -Encoding UTF8

Write-Host "`nLab 03 tamamlandı." -ForegroundColor Green
Write-Host "Özel kanıt dizini: $runDirectory"
Write-Host "Doğru imza çıkış kodu: $goodExitCode (beklenen 0)"
Write-Host "Değiştirilmiş firmware çıkış kodu: $tamperedExitCode (beklenen 0 dışı)"
Write-Host "Yanlış anahtar çıkış kodu: $wrongKeyExitCode (beklenen 0 dışı)"
Write-Host "Özet: $summaryPath"

if ($goodExitCode -ne 0 -or $tamperedExitCode -eq 0 -or $wrongKeyExitCode -eq 0) {
    throw 'Deney sonuçlarından en az biri beklenen güvenlik kararını üretmedi.'
}
