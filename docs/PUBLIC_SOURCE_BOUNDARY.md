# Public Source Boundary

This repository is the public, evidence-oriented learning layer of the embedded-security study project.

## Included

- Original host-side educational security models and tests.
- Hands-on labs for signatures, trust anchors, revocation, authenticated containers, lifecycle, anti-rollback, A/B recovery, manifests, SBOM/VEX and evidence.
- Architecture notes that clearly distinguish study models from real-silicon proof.
- ESP32 hardware workflow, where real-device evidence can be collected.
- Obsidian study/presentation material and quiz assets.

## Intentionally not redistributed

- Internship/internal PDFs or reports.
- Notebook photographs.
- Proprietary or confidential vendor/company source packages.
- Private signing keys, certificates, generated secrets or fuse dumps.
- Any artifact whose license does not permit public redistribution.

The absence of those source artifacts is deliberate. Public proof-of-work should demonstrate what was learned and tested without republishing restricted material.

## Evidence labels

- `HOST_VERIFIED`: executable host-side model/test passed.
- `SOURCE_REVIEWED`: architecture/source material was studied; this is not hardware proof.
- `HARDWARE_PENDING`: requires the actual target board/silicon.
- `HARDWARE_VERIFIED`: only after evidence is captured from the physical target.

At present, ESP32 is the real hardware track. i.MX93 and EFR32 remain study/reference tracks unless the corresponding hardware becomes available.
