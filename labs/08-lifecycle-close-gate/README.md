# Lab 08 — Lifecycle & Irreversible Close Gate

## Goal
Understand the difference between authenticating an image and actually enforcing rejection, and why production lifecycle transitions must be treated as irreversible operations.

## Model

```text
Development/Open
  → establish trust anchor
  → prove signed known-good image
  → negative tests: tamper / wrong key / unsigned
  → recovery proof
  → key backup
  → close/provision checklist
  → Production/Closed
```

## Gate
Do not perform a real lifecycle/eFuse transition unless:

- exact silicon/revision is known;
- official documentation for that target is open;
- trusted signing key is backed up;
- known-good recovery image exists;
- negative tests pass;
- recovery/reflash path is proven;
- stable power is available;
- before-state evidence is captured.

## Explain back
Why is “the device can authenticate a signature” different from “the device refuses unauthenticated code”? Why should close/provision be the last step rather than the first?

## Evidence
Checklist + negative-test logs. Real lifecycle claims require `HARDWARE_VERIFIED` evidence.