# Learning Path

Use the repository in this order. The point is not to finish files; the point is to be able to explain the security decision, break it intentionally, and show evidence.

1. **Integrity** — hash a payload, modify one bit, explain why the digest changes.
2. **Authenticity** — sign and verify with ECDSA; then test the wrong key and tampered payload.
3. **Release identity** — create a manifest, metadata and artifact hashes.
4. **Trust anchors** — model multiple trusted keys, selected key, rotation and revocation.
5. **Authenticated container** — verify metadata, signature, payload hash and version policy.
6. **Lifecycle** — understand development/open vs production/closed enforcement and irreversible gates.
7. **Update safety** — A/B update, recovery rollback and anti-rollback are separate mechanisms.
8. **Boot-chain architecture** — map i.MX93/AHAB concepts without claiming hardware proof.
9. **Abstraction** — separate common policy/status from platform-specific trust roots and provisioning.
10. **SBOM/VEX/traceability** — connect requirement → mechanism → test → acceptance → evidence.
11. **ESP32 hardware** — repeat the concepts on the real board and collect serial/eFuse/build evidence.
12. **Capstone** — package only claims supported by their evidence level.

## Explain-back gate

Do not mark a topic complete until you can answer:

- What problem does this mechanism solve?
- What does it *not* solve?
- Where is the trust anchor?
- What negative test would prove the control is actually enforced?
- What artifact would you show to another engineer as evidence?
- Is the result host-verified, source-reviewed, hardware-pending or hardware-verified?
