# Profil 1 — Kaynak ve Derleme Kanıtı

- Tarih: 14 Eylül 2026
- Hedef: ESP32-C3
- ESP-IDF: v6.0.2
- Flash düzeni: 4 MB, iki adet 1.5 MB OTA uygulama bölümü

## Deney hipotezi

Bir OTA istemcisi firmware'i düz HTTP üzerinden indirir ve image kökenini dijital imzayla doğrulamazsa, ESP32 biçimsel olarak geçerli fakat yetkisiz bir firmware'i yazıp çalıştırabilir.

## Oluşturulan iki ayrı program

| Program | Sürüm | Görevi |
|---|---|---|
| `insecure_ota_client.bin` | `insecure-client-1.0.0` | Wi-Fi'ye bağlanır, HTTP URL'sinden image indirir ve pasif OTA bölümüne yazar. |
| `untrusted_update.bin` | `untrusted-update-1.0.0` | Açıldığında `UNTRUSTED_OTA_FIRMWARE_RUNNING` kanıt işaretini basar. |

## Derleme sonucu

| Dosya | Boyut | SHA-256 |
|---|---:|---|
| `insecure_ota_client.bin` | 963168 bayt | `44F72C57A7C54640C115786048708DB247AC1E4B151356E749360234777BAEC0` |
| `untrusted_update.bin` | 141904 bayt | `58C215CF8842307DAB82D24B26C9051C1FE94CEAFCE427BA73996CB194040A13` |

Her iki kaynak ESP-IDF ile hatasız derlendi. OTA istemcisi image'ı 1.5 MB'lık en küçük uygulama bölümüne sığdı ve bölümde yaklaşık %39 boş alan kaldı.

Yerel HTTP sunucusu `127.0.0.1:18070` üzerinde test edildi. Sunucudan 141904 bayt indirildi ve indirilen dosyanın SHA-256 değeri kaynak `untrusted_update.bin` ile eşleşti. Böylece sunma/indirme hattının dosyayı değiştirmeden taşıdığı doğrulandı.

## Yapılandırma kanıtı

- `CONFIG_ESP_HTTPS_OTA_ALLOW_HTTP=y`: istemci bilerek düz HTTP kabul ediyor.
- `CONFIG_SECURE_BOOT is not set`: Secure Boot kapalı.
- `CONFIG_FLASH_ENCRYPTION_ENABLED is not set`: Flash Encryption kapalı.
- OTA bölümleri `ota_0` adres `0x20000` ve `ota_1` adres `0x1A0000`.
- Wi-Fi parolası ve gerçek sunucu adresi kaynak kodda değil, Git'in yok saydığı `.private/sdkconfig.defaults` içinde tutulacak.

## Donanım sonucu

Deney ESP32-C3 revizyon v0.4 üzerinde tamamlandı. İstemci `ota_0` bölümünden açıldı, düz HTTP üzerinden image'ı indirdi ve onu pasif `ota_1` bölümüne yazdı. Seri logda sırasıyla şu işaretler görüldü:

1. `PROFILE_1_INSECURE_HTTP_OTA_CLIENT`
2. `Writing to <ota_1> partition at offset 0x1a0000`
3. `INSECURE_OTA_ACCEPTED_IMAGE`
4. yeniden başlatmadan sonra `UNTRUSTED_OTA_FIRMWARE_RUNNING`

Bootloader yeni uygulamayı `0x1a0000` adresinden yükledi. OTA sunucusu da kartın `untrusted_update.bin` için yaptığı başarılı HTTP `GET` isteğini kaydetti.

Son olarak `ota_1` içinden 141904 bayt geri okundu. Geri okunan verinin SHA-256 değeri `58C215CF8842307DAB82D24B26C9051C1FE94CEAFCE427BA73996CB194040A13` çıktı ve sunulan `untrusted_update.bin` ile birebir eşleşti. Böylece yalnız log mesajı değil, flash'a yazılan gerçek baytlar da doğrulandı.

Ayrıntılı deney akışı ve kanıtlar [HARDWARE_REPORT.md](HARDWARE_REPORT.md) dosyasındadır.

## Terimler

- **OTA (Over-the-Air):** Firmware'in kabloyla değil ağ üzerinden güncellenmesi.
- **OTA slotu/bölümü:** Flash içinde bir uygulama image'ını taşıyan alan. İki slot, çalışan uygulama korunurken diğerine yeni image yazılmasını sağlar.
- **Pasif bölüm:** O anda çalışmayan, yeni firmware'in yazılacağı OTA bölümü.
- **HTTP:** Veriyi şifrelemeyen ve sunucunun kimliğini doğrulamayan uygulama protokolü.
- **SHA-256:** Dosyanın özetini çıkarır; tek başına üreticinin kimliğini veya yetkisini kanıtlamaz.
- **Dijital imza:** Image özetini özel anahtarla ilişkilendirerek firmware'in yetkili üreticiden geldiğinin doğrulanmasını sağlar.
- **Secure Boot:** Boot zincirinde yalnız güvenilir anahtarla imzalanmış kodun çalıştırılmasını zorlar.
- **Flash Encryption:** Harici flash içeriğini cihaz dışından okunmaya karşı şifreler; OTA sunucusunun kimliğini doğrulamanın yerine geçmez.
