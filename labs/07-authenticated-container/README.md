# Lab 07 — Authenticated Container Mental Model

## Goal
Model what a secure boot container must bind together: metadata, selected signer, payload hash, target/version policy and the payload itself.

This lab is **AHAB-inspired**, not an NXP AHAB binary parser.

## Exercise
Create a small JSON descriptor containing image name, load/entry metadata, security version and SHA-256 payload hash. Sign the descriptor with a development key. Then run four negative tests:

- modify the payload;
- modify signed metadata;
- use an untrusted/wrong key;
- lower the security version below policy.

## Acceptance
Every unauthorized change must produce an explicit rejection reason. A successful signature alone is not enough if the payload hash or anti-rollback policy fails.

## Explain back
Why should a container authenticate both metadata and payload identity? What security property is lost if an attacker can change load address or version metadata without invalidating authentication?

## Evidence level
Host experiment: `HOST_VERIFIED`. Vendor binary-format behavior: `SOURCE_REVIEWED` / `HARDWARE_PENDING`.