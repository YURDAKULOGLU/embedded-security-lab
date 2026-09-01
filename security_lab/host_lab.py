"""Runnable host-side embedded-security learning models.

This is deliberately vendor-neutral: it models security decisions, not NXP AHAB,
Silicon Labs GBL, or Espressif binary formats. Use it to learn the invariant
properties before moving to the ESP32 hardware track.
"""
from __future__ import annotations

import hashlib
import json
from dataclasses import dataclass, field, asdict
from pathlib import Path
from typing import Iterable


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


@dataclass(frozen=True)
class TrustKey:
    key_id: int
    public_material: str


@dataclass
class TrustStore:
    keys: list[TrustKey]
    revoked_mask: int = 0

    @property
    def trust_anchor(self) -> str:
        canonical = json.dumps([asdict(k) for k in self.keys], sort_keys=True).encode()
        return sha256(canonical)

    def is_revoked(self, key_id: int) -> bool:
        return bool(self.revoked_mask & (1 << key_id))

    def revoke(self, key_id: int) -> None:
        if key_id < 0 or key_id >= len(self.keys):
            raise ValueError("invalid key id")
        self.revoked_mask |= 1 << key_id


@dataclass(frozen=True)
class SignedImage:
    version: int
    security_version: int
    payload: bytes
    signer_id: int
    expected_hash: str

    @classmethod
    def build(cls, payload: bytes, version: int, security_version: int, signer_id: int):
        return cls(version, security_version, payload, signer_id, sha256(payload))


@dataclass
class BootPolicy:
    minimum_security_version: int = 0
    enforce_authentication: bool = True


@dataclass(frozen=True)
class Verification:
    accepted: bool
    events: tuple[str, ...]


def verify_image(image: SignedImage, trust: TrustStore, policy: BootPolicy) -> Verification:
    events: list[str] = []
    if image.signer_id >= len(trust.keys):
        events.append("UNKNOWN_SIGNER")
    elif trust.is_revoked(image.signer_id):
        events.append("SIGNER_REVOKED")
    if sha256(image.payload) != image.expected_hash:
        events.append("PAYLOAD_TAMPERED")
    if image.security_version < policy.minimum_security_version:
        events.append("ANTI_ROLLBACK_REJECT")
    accepted = not events if policy.enforce_authentication else not any(
        e == "ANTI_ROLLBACK_REJECT" for e in events
    )
    return Verification(accepted, tuple(events))


@dataclass
class Slot:
    name: str
    image: SignedImage | None = None
    healthy: bool = False
    boot_attempts: int = 0


@dataclass
class ABDevice:
    active: str = "A"
    slots: dict[str, Slot] = field(default_factory=lambda: {"A": Slot("A"), "B": Slot("B")})
    max_attempts: int = 2

    def inactive(self) -> str:
        return "B" if self.active == "A" else "A"

    def stage(self, image: SignedImage) -> str:
        target = self.inactive()
        self.slots[target] = Slot(target, image=image)
        return target

    def try_activate(self, target: str, boot_ok: bool) -> str:
        slot = self.slots[target]
        slot.boot_attempts += 1
        if boot_ok:
            slot.healthy = True
            self.active = target
            return "ACTIVATED"
        if slot.boot_attempts >= self.max_attempts:
            return "ROLLBACK_TO_KNOWN_GOOD"
        return "RETRY"


def make_manifest(product: str, release: str, artifacts: Iterable[Path]) -> dict:
    items = []
    for p in artifacts:
        items.append({"path": p.name, "sha256": sha256(p.read_bytes()), "size": p.stat().st_size})
    return {"product": product, "release": release, "artifacts": items}


def demo() -> dict:
    trust = TrustStore([TrustKey(i, f"public-key-{i}") for i in range(4)])
    good = SignedImage.build(b"firmware-v3", 3, 3, 0)
    good_result = verify_image(good, trust, BootPolicy(minimum_security_version=2))

    tampered = SignedImage(good.version, good.security_version, b"firmware-HACKED", good.signer_id, good.expected_hash)
    tamper_result = verify_image(tampered, trust, BootPolicy(minimum_security_version=2))

    trust.revoke(0)
    revoked_result = verify_image(good, trust, BootPolicy(minimum_security_version=2))

    old = SignedImage.build(b"old-but-valid", 1, 1, 1)
    rollback_result = verify_image(old, trust, BootPolicy(minimum_security_version=2))

    device = ABDevice()
    device.slots["A"] = Slot("A", image=good, healthy=True)
    target = device.stage(SignedImage.build(b"firmware-v4", 4, 4, 1))
    first = device.try_activate(target, boot_ok=False)
    second = device.try_activate(target, boot_ok=False)

    return {
        "trust_anchor": trust.trust_anchor,
        "good_accepted": good_result.accepted,
        "tamper_rejected": not tamper_result.accepted,
        "revoked_key_rejected": not revoked_result.accepted,
        "antirollback_rejected": not rollback_result.accepted,
        "ab_first_failure": first,
        "ab_second_failure": second,
        "active_slot_after_failed_update": device.active,
    }


if __name__ == "__main__":
    print(json.dumps(demo(), indent=2))
