# Lab 10 — Requirement → Mechanism → Test → Evidence

## Goal
Turn security knowledge into an auditable engineering argument.

For each control, write five fields:

| Requirement | Mechanism | Negative test | Acceptance criterion | Evidence |
|---|---|---|---|---|
| Unauthorized firmware must not execute | Signed/verified boot | Tamper payload | Boot/verification is rejected | Serial/test log |
| Vulnerable old release must not return | Security version | Present old signed image | Image rejected | Version-policy log |
| Failed update must not brick device | A/B recovery | Simulate failed boot | Known-good slot retained | Slot-state log |

Then add an evidence label: `HOST_VERIFIED`, `SOURCE_REVIEWED`, `HARDWARE_PENDING`, or `HARDWARE_VERIFIED`.

## Rule
Do not write “implemented” when the evidence only shows a design or host model. The quality of this repository comes from preserving that boundary.

## Deliverable
A one-page traceability table for Secure Boot, update, anti-rollback, device identity/key protection, SBOM/vulnerability handling and decommissioning.