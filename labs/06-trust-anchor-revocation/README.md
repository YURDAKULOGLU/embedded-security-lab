# Lab 06 — Trust Anchor, Key Rotation & Revocation

## Goal
Understand the difference between a trusted key set, its trust-anchor digest, selecting a signing key, rotating to another key, and revoking a compromised key.

## Run

```bash
python -m security_lab.host_lab
python -m unittest tests.test_host_lab -v
```

## Break it deliberately

1. Build an image signed by logical key `0`.
2. Verify it while key `0` is trusted.
3. Revoke key `0` in the revocation mask.
4. Verify the same otherwise-valid image again.
5. Build the next image with key `1` and verify that rotation still permits a trusted non-revoked signer.

## Explain back

- Why is revocation not the same as deleting a key from a table?
- Why must the device have a trust anchor that an attacker cannot freely replace?
- What happens operationally if every trusted key is revoked?

## Evidence
Save the before/after verification result and your explanation. Host output is `HOST_VERIFIED`; it is not proof of a particular vendor fuse layout.