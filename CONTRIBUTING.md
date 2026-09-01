# Contributing

This repository is a learning and proof-of-work lab. Contributions should preserve the distinction between models, source review and real hardware evidence.

## Rules

- Never commit private signing keys, certificates containing secrets, passwords or tokens.
- Never publish internship/internal documents or proprietary source without explicit redistribution rights.
- Mark hardware-specific claims with the exact target/revision and evidence level.
- Every security control should include at least one negative test where practical.
- Irreversible eFuse/OTP/lifecycle operations must remain behind explicit checklists.
- Host-side models must not be described as exact vendor binary formats unless they actually implement and verify that format.

## Evidence vocabulary

Use one of: `HOST_VERIFIED`, `SOURCE_REVIEWED`, `HARDWARE_PENDING`, `HARDWARE_VERIFIED`.

## Pull requests

Include what changed, what was tested, the expected failure case, and which evidence artifacts were produced. Do not attach secrets or restricted source material.