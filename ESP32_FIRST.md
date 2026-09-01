# ESP32 First — Real Hardware Proof Track

ESP32 is the physical target currently available for this lab. This track turns the host-side concepts into real evidence without pretending that i.MX93 or EFR32 hardware was tested.

## 0. Inventory before security changes

Record before burning any eFuse:

- Exact board name
- Exact SoC target (`esp32`, `esp32s3`, `esp32c3`, etc.)
- Chip revision
- ESP-IDF version
- Flash size / partition table
- Current Secure Boot state
- Current Flash Encryption state
- Relevant eFuse summary

Store the output under a dated evidence directory. Do not publish device-unique secrets.

## 1. Baseline

Build, flash and capture a normal boot log before enabling irreversible security features. Confirm that recovery and reflashing work.

## 2. Signed-boot learning phase

Use the exact ESP-IDF documentation for the detected target/revision. Generate development signing material locally; never commit private keys. Capture build configuration and signature-related output.

## 3. Negative tests

Before irreversible provisioning, prove that you understand the failure modes:

- Untampered signed application boots.
- Modified application is rejected under the configured verification path.
- Wrong signing key is rejected where the target/configuration supports the test.
- OTA candidate failure does not destroy the known-good recovery path.

## 4. OTA + rollback / anti-rollback

Exercise A/B or OTA-slot behavior first without permanently advancing security-version fuses. Separate:

- rollback = recovery to a known-good image;
- anti-rollback = refusal to boot software below the minimum security version.

Only advance irreversible version state after recovery has been demonstrated.

## 5. Irreversible gate

Before any eFuse operation, require all of the following:

- Exact chip/revision confirmed.
- Official documentation for that exact target open.
- Signing keys backed up offline.
- Known-good signed recovery image available.
- Serial boot evidence captured.
- Negative tests passed.
- Power is stable.
- You understand which eFuse bits are one-way.

If any item is missing, stop.

## Evidence package

A hardware-verified run should contain at least:

```text
evidence/esp32/YYYY-MM-DD-run-N/
├── inventory.txt
├── sdk-version.txt
├── efuse-before.txt
├── build-config.txt
├── baseline-boot.log
├── signed-boot.log
├── tamper-negative.log
├── ota-recovery.log
├── efuse-after.txt        # only if intentionally provisioned
└── RUN_NOTES.md
```

The final report should distinguish `HOST_VERIFIED`, `SOURCE_REVIEWED`, `HARDWARE_PENDING` and `HARDWARE_VERIFIED` claims.