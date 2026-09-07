# Lab 03 — Firmware İmzalama

Bu laboratuvar donanıma kalıcı güvenlik ayarı yazmadan hash, özel anahtar, açık anahtar, imza üretimi ve imza doğrulamasını öğretir. İmzalanmış, imzasız ve tek byte değiştirilmiş görüntüler karşılaştırılacaktır.

## Araştırma sorusu

Bir saldırgan firmware'i ve yanında tutulan hash değerini değiştirebiliyorsa cihaz yetkili firmware'i nasıl ayırt eder?

## Kullandığımız gerçek mekanizma

- ESP-IDF 6.0.2 içindeki `espsecure` aracı
- Secure Boot V2 biçimi
- RSA-3072 anahtar
- SHA-256 özeti
- RSA-PSS dijital imzası

Bu laboratuvar sahte bir `signer_id` veya yalnız hash karşılaştırması kullanmaz. Gerçek özel anahtarla imza üretir ve gerçek açık anahtarla doğrular.

## Deney matrisi

| Deney | Beklenen sonuç |
|---|---|
| Doğru anahtarla imzalanmış firmware | Kabul |
| İmzalandıktan sonra bir baytı değiştirilmiş firmware | Ret |
| Başka anahtarın açık anahtarıyla doğrulama | Ret |

## Çalıştırma

Önce ESP-IDF ortamını aç:

```powershell
. .\scripts\Enter-EspIdf.ps1
```

Sonra proje kökünden:

```powershell
.\labs\03-firmware-signing\Run-Lab.ps1
```

Özel anahtarlar ve üretilen binary dosyaları `evidence/private/` altında tutulur ve Git tarafından yok sayılır.

## Kanıt sınırı

Bu deney `HOST_VERIFIED` seviyesindedir. Gerçek kriptografik imzayı kanıtlar; ESP32-C3 ROM'unun veya eFuse donanımının davranışını kanıtlamaz.
