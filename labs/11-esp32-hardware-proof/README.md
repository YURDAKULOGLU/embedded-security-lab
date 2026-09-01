# Lab 11 — ESP32 Real Hardware Proof

This is the primary physical-hardware track. Read `ESP32_FIRST.md` before doing anything irreversible.

## Phase A — inventory
Capture exact board, SoC target, chip revision, ESP-IDF version, partition table, Secure Boot state, Flash Encryption state and eFuse summary.

## Phase B — baseline
Build/flash a minimal known-good application and save the serial boot log. Prove recovery/reflash works before security provisioning.

## Phase C — signed boot
Follow the official ESP-IDF documentation for the exact detected target/revision. Keep signing keys outside Git. Capture build configuration and boot evidence.

## Phase D — negative tests
Run only tests supported safely by the exact target/configuration:

- known-good signed image;
- tampered image;
- wrong/untrusted signing key;
- OTA candidate that fails health validation;
- old security-version image after anti-rollback is intentionally configured.

## Phase E — irreversible gate
Only after recovery + negative tests are proven should eFuse changes be considered. Capture before/after eFuse summaries, but never publish secrets.

## Definition of done
A claim becomes `HARDWARE_VERIFIED` only when the repository contains a reproducible run note with target/revision, toolchain version, command/config context, expected result and captured device evidence.