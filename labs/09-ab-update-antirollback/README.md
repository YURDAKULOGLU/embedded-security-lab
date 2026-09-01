# Lab 09 — A/B Update, Recovery, Rollback & Anti-Rollback

## Goal
Stop treating rollback and anti-rollback as the same feature.

- **Rollback/recovery:** a new image fails, so the device returns to a known-good slot.
- **Anti-rollback:** an old but correctly signed vulnerable image is below the minimum security version and must be refused.

## Run

```bash
python -m security_lab.host_lab
python -m unittest tests.test_host_lab.HostLifecycleLabTests.test_failed_ab_update_keeps_known_good_slot -v
python -m unittest tests.test_host_lab.HostLifecycleLabTests.test_antirollback_is_rejected -v
```

## Negative tests

1. Stage a new image in the inactive slot and simulate repeated boot failure.
2. Confirm the active known-good slot remains available.
3. Present an old, otherwise-valid image below minimum security version.
4. Confirm anti-rollback rejects it.

## Explain back
Why can a properly signed old image still be dangerous? Why should a monotonic/security-version state only advance after the new image is proven healthy?

## Evidence
Test output + a state diagram showing active/inactive slots and minimum security version.