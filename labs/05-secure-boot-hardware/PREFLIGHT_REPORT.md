# ESP32-C3 Secure Boot — Donanım Ön Kontrol Raporu

## Kapsam

Bu rapor yalnızca kartın mevcut durumunun okunmasını kapsar. Hiçbir eFuse biti yazılmamış, anahtar provision edilmemiş ve Secure Boot etkinleştirilmemiştir.

## Kanıt seviyesi

- Kart envanteri: `HARDWARE_VERIFIED`
- Secure Boot aktivasyonu: `HARDWARE_PENDING`
- Tarih: 2026-09-07
- Araçlar: ESP-IDF 6.0.2, esptool 5.3.1, espefuse 5.3.1

## Donanım

| Alan | Okunan değer |
|---|---|
| SoC | ESP32-C3, QFN32 |
| Çip revizyonu | v0.4 |
| CPU | Tek çekirdek, 160 MHz, RISC-V |
| Fiziksel flash | 4 MB, XMC |
| Kristal | 40 MHz |
| Bağlantı | USB-Serial/JTAG |

Cihaza özgü MAC ve optional unique ID public rapora eklenmemiştir.

## Güvenlik eFuse özeti

| Güvenlik alanı | Değer | Yorum |
|---|---|---|
| `SECURE_BOOT_EN` | `False` | Donanımsal Secure Boot etkin değil. |
| `SPI_BOOT_CRYPT_CNT` | `0b000` / Disabled | Flash Encryption etkin değil. |
| `SECURE_VERSION` | `0` | Anti-rollback minimum sürümü ilerletilmemiş. |
| `SECURE_BOOT_KEY_REVOKE0..2` | `False` | Hiçbir Secure Boot anahtarı iptal edilmemiş. |
| `KEY_PURPOSE_0..5` | `USER` | Secure Boot digest amacı atanmış key block yok. |
| `BLOCK_KEY0..5` | Boş | Herhangi bir Secure Boot anahtar özeti provision edilmemiş. |
| `SOFT_DIS_JTAG` | `0` | JTAG yazılımsal olarak kapatılmamış. |
| `DIS_PAD_JTAG` | `False` | JTAG kalıcı olarak kapatılmamış. |
| `DIS_DOWNLOAD_MODE` | `False` | ROM download mode kapatılmamış. |
| `DIS_USB_SERIAL_JTAG` | `False` | USB Serial/JTAG kullanılabilir. |
| `WR_DIS` | `0` | eFuse yazma koruma bitleri uygulanmamış. |

## Yorum

Kart geliştirme durumundadır ve daha önce Secure Boot için provision edilmemiş görünmektedir. Bu durum geri döndürülebilir imzalama, derleme ve QEMU testlerinin yapılmasına uygundur. Donanımsal aktivasyondan önce doğru signing key yedeği, imzalı recovery image, negatif test kanıtları ve eFuse yazma planı hazırlanmalıdır.

## Ham kanıt

Ham `chip-id` ve `espefuse summary` çıktıları benzersiz cihaz kimlikleri içerdiğinden `evidence/private/hardware-inventory/` altında Git dışında tutulur.

## Sonraki güvenli adım

Secure Boot V2 yapılandırılmış bootloader ve application binary'leri üretilecek, ancak donanıma flashlanmayacaktır. Önce QEMU üzerinde imzalı ve değiştirilmiş image davranışları doğrulanacaktır.
