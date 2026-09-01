import unittest

from security_lab.host_lab import (
    ABDevice, BootPolicy, SignedImage, Slot, TrustKey, TrustStore, demo, verify_image
)


class HostLifecycleLabTests(unittest.TestCase):
    def setUp(self):
        self.trust = TrustStore([TrustKey(i, f"key-{i}") for i in range(4)])
        self.policy = BootPolicy(minimum_security_version=2)

    def test_good_image_is_accepted(self):
        image = SignedImage.build(b"good", 3, 3, 0)
        self.assertTrue(verify_image(image, self.trust, self.policy).accepted)

    def test_tamper_is_rejected(self):
        good = SignedImage.build(b"good", 3, 3, 0)
        tampered = SignedImage(3, 3, b"bad", 0, good.expected_hash)
        result = verify_image(tampered, self.trust, self.policy)
        self.assertFalse(result.accepted)
        self.assertIn("PAYLOAD_TAMPERED", result.events)

    def test_revocation_is_rejected(self):
        image = SignedImage.build(b"good", 3, 3, 0)
        self.trust.revoke(0)
        self.assertFalse(verify_image(image, self.trust, self.policy).accepted)

    def test_antirollback_is_rejected(self):
        old = SignedImage.build(b"old", 1, 1, 1)
        result = verify_image(old, self.trust, self.policy)
        self.assertFalse(result.accepted)
        self.assertIn("ANTI_ROLLBACK_REJECT", result.events)

    def test_failed_ab_update_keeps_known_good_slot(self):
        device = ABDevice()
        device.slots["A"] = Slot("A", SignedImage.build(b"v3", 3, 3, 0), True)
        target = device.stage(SignedImage.build(b"v4", 4, 4, 1))
        self.assertEqual(device.try_activate(target, False), "RETRY")
        self.assertEqual(device.try_activate(target, False), "ROLLBACK_TO_KNOWN_GOOD")
        self.assertEqual(device.active, "A")

    def test_demo_expected_security_properties(self):
        result = demo()
        self.assertTrue(result["good_accepted"])
        self.assertTrue(result["tamper_rejected"])
        self.assertTrue(result["revoked_key_rejected"])
        self.assertTrue(result["antirollback_rejected"])
        self.assertEqual(result["active_slot_after_failed_update"], "A")


if __name__ == "__main__":
    unittest.main()
