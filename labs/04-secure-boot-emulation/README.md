# Lab 04 — Secure Boot Emülasyonu

Secure Boot akışı uygun ESP32 QEMU hedefinde denenir. Başarılı imzalı boot ile değiştirilmiş veya yanlış anahtarla imzalanmış görüntünün reddedilmesi karşılaştırılır. Fiziksel eFuse kullanılmaz.

## Güvenlik sınırı

Bu klasördeki bootloader gerçek karta flashlanmaz. `CONFIG_SECURE_BOOT=y` ile üretilen bootloader ilk fiziksel açılışta kalıcı eFuse değişiklikleri yapabilir. Deney yalnız QEMU içindir.

## Yapılandırma

- Hedef: ESP32-C3 revizyon v0.3 veya üzeri
- Secure Boot: V2
- İmza: RSA-3072 / RSA-PSS / SHA-256
- Bootloader ve uygulama: build sırasında imzalı
- QEMU flash image: imzalı bootloader dâhil

Private key `.private/` altında üretilir ve Git tarafından yok sayılır.

## Doğrulanan sonuç

Lab 7 Eylül 2026 tarihinde tamamlandı:

- Geçerli imzalı bootloader ve uygulama QEMU'da açıldı.
- Uygulama içeriğindeki tek bit değişikliği checksum kontrolünde reddedildi.
- RSA imzasındaki tek bit değişikliği Secure Boot V2 doğrulamasında reddedildi.
- Gerçek karta flash veya eFuse yazımı yapılmadı.

Ayrıntılı kanıt ve kavram açıklamaları için [LAB_REPORT.md](LAB_REPORT.md) dosyasına bakın.
