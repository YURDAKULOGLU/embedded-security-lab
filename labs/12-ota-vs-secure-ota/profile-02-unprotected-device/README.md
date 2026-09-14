# Profil 2 — Secure Boot ve Flash Encryption Kapalı

## Öğrenme sorusu

Flash düz metinken ve boot sırasında imza enforcement yokken fiziksel erişimli bir saldırgan hangi varlıkları elde edebilir veya değiştirebilir?

## Güvensiz profil

- Yalnız sahte laboratuvar sırları firmware'e gömülür.
- Flash `read-flash` ile geri okunur.
- Sahte marker'lar `strings` ve hex incelemesiyle aranır.
- Secure Boot kapalı olduğu için yetkisiz image riski ayrı negatif testte gösterilir.

## Secure OTA kapatması

- Önce QEMU'da Secure Boot ve Flash Encryption tasarımı doğrulanır.
- Recovery image, signing-key yedeği ve negatif testler hazırlanır.
- Gerçek kart eFuse işlemi ayrı ve açık onaylı güvenlik kapısıdır.

Gerçek parola, token veya üretim sırrı kullanılmaz.
