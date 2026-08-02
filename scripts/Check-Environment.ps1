$ErrorActionPreference = 'Continue'

$checks = @(
    @{ Name = 'Git'; Command = { git --version } },
    @{ Name = 'Python'; Command = { python --version } },
    @{ Name = 'ESP-IDF'; Command = { idf.py --version } },
    @{ Name = 'CMake'; Command = { cmake --version | Select-Object -First 1 } },
    @{ Name = 'Ninja'; Command = { ninja --version } },
    @{ Name = 'Xtensa GCC'; Command = { xtensa-esp-elf-gcc --version | Select-Object -First 1 } },
    @{ Name = 'RISC-V GCC'; Command = { riscv32-esp-elf-gcc --version | Select-Object -First 1 } },
    @{ Name = 'esptool'; Command = { esptool version } }
)

foreach ($check in $checks) {
    try {
        $value = & $check.Command 2>&1
        [pscustomobject]@{
            Check = $check.Name
            Status = if ($LASTEXITCODE -eq 0 -or $null -eq $LASTEXITCODE) { 'OK' } else { 'FAIL' }
            Value = ($value -join ' ').Trim()
        }
    }
    catch {
        [pscustomobject]@{
            Check = $check.Name
            Status = 'FAIL'
            Value = $_.Exception.Message
        }
    }
}

Write-Host "`nAlgılanan seri aygıtlar:" -ForegroundColor Cyan
Get-CimInstance Win32_PnPEntity |
    Where-Object { $_.Name -match 'COM\d+|CP210|CH340|CH343|USB Serial|JTAG' } |
    Select-Object Name, DeviceID |
    Format-Table -AutoSize
