# Evidence

Generated evidence belongs in dated/run-specific folders and should never contain private keys or secrets.

Recommended structure:

```text
evidence/<platform>/<date>-run-<n>/
├── inventory.txt
├── build-config.txt
├── positive-test.log
├── negative-test.log
├── summary.md
└── hashes.sha256
```

A result is not `HARDWARE_VERIFIED` until it comes from the physical target and includes enough context to reproduce the test.