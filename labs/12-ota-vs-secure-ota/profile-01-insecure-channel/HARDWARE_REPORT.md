# Profil 1 — ESP32-C3 Donanım Deney Raporu

## Amaç

Düz HTTP kullanan ve firmware'in yetkili üreticiden geldiğini dijital imzayla doğrulamayan OTA istemcisinin, biçimsel olarak geçerli fakat güvenilmeyen bir firmware'i kabul edip çalıştırabildiğini gerçek kart üzerinde göstermek.

## Deney ortamı

- Kart: ESP32-C3, QFN32, revizyon v0.4
- Flash: 4 MB fiziksel flash
- Geliştirme çatısı: ESP-IDF v6.0.2
- Seri port: COM8, 115200 baud
- Ağ: bilgisayarda açılan izole 2.4 GHz mobil erişim noktası
- OTA sunucusu: bilgisayarda çalışan yerel HTTP sunucusu, port 8070
- Güvenlik durumu: Secure Boot kapalı, Flash Encryption kapalı

Wi-Fi parolası ve özel ağ ayarları repoya eklenmedi. Bunlar yalnız Git'in yok saydığı `.private/sdkconfig.defaults` dosyasında kullanıldı.

## Hipotez

İstemci yalnız ESP32 application image biçimini kontrol eder, fakat kaynağı TLS sertifikası veya dijital imzayla doğrulamazsa saldırganın sunduğu geçerli bir image'ı OTA güncellemesi sanarak çalıştırabilir.

## Uygulanan deney

1. `insecure_ota_client` gerçek ağ ayarlarıyla derlendi.
2. Bootloader, partition table, OTA metadata ve istemci uygulaması karta yazıldı.
3. Bilgisayarda `untrusted_update.bin` dosyasını sunan HTTP sunucusu başlatıldı.
4. Kart erişim noktasına bağlandı ve OTA URL'sine HTTP isteği gönderdi.
5. İstemci, çalışmayan `ota_1` bölümüne indirilen image'ı yazdı.
6. OTA boot seçimi `ota_1` olacak şekilde değiştirildi ve kart yeniden başlatıldı.
7. Yeni uygulamanın marker mesajı seri portta gözlendi.
8. `ota_1` içindeki baytlar bilgisayara geri okunup kaynak image ile karşılaştırıldı.

## Seri port kanıtı

Önemli log satırları:

```text
PROFILE_1_INSECURE_HTTP_OTA_CLIENT
Running partition: ota_0 at 0x20000
Passive partition: ota_1 at 0x1a0000
Downloading unauthenticated image from http://192.168.137.1:8070/untrusted_update.bin
Continuing with insecure option because CONFIG_ESP_HTTPS_OTA_ALLOW_HTTP is set.
Writing to <ota_1> partition at offset 0x1a0000
INSECURE_OTA_ACCEPTED_IMAGE
```

Yeniden başlatmadan sonra:

```text
Loaded app from partition at offset 0x1a0000
Project name: untrusted_update
App version: untrusted-update-1.0.0
UNTRUSTED_OTA_FIRMWARE_RUNNING
Running partition: ota_1 at 0x1a0000
```

## Sunucu tarafı kanıtı

HTTP sunucusu kartın OTA dosyasını gerçekten istediğini kaydetti:

```text
192.168.137.142 - - [14/Sep/2026 13:44:18] "GET /untrusted_update.bin HTTP/1.1" 200 -
```

Buradaki `200`, sunucunun isteği başarıyla cevapladığını belirten HTTP durum kodudur.

## Flash geri-okuma kanıtı

`ota_1` başlangıç adresi `0x1A0000` üzerinden image boyutu kadar, yani 141904 bayt geri okundu.

| Veri | SHA-256 |
|---|---|
| Sunucunun sunduğu `untrusted_update.bin` | `58C215CF8842307DAB82D24B26C9051C1FE94CEAFCE427BA73996CB194040A13` |
| Kartın `ota_1` bölümünden geri okunan veri | `58C215CF8842307DAB82D24B26C9051C1FE94CEAFCE427BA73996CB194040A13` |

İki özetin eşleşmesi, sunulan image'ın kartın flash belleğine değişmeden yazıldığını kanıtlar.

## Sonuç

Hipotez doğrulandı: biçimsel olarak geçerli olmak, firmware'in güvenilir olduğu anlamına gelmez. Bu profil HTTP kullandığı için sunucunun kimliğini doğrulamadı; ayrıca çalıştırılacak kodun yetkili anahtarla imzalanmasını zorlayan Secure Boot da kapalıydı. Sonuç olarak güvenilmeyen test firmware'i kabul edildi ve boot edildi.

SHA-256 burada yalnız iki veri kopyasının aynı olduğunu kanıtladı. Image'ın kim tarafından üretildiğini veya çalıştırılmaya yetkili olduğunu kanıtlamadı. Bunun için HTTPS sertifika doğrulaması, firmware imzası ve cihazın tehdit modeline göre Secure Boot gibi güven mekanizmaları gerekir.

## Sonraki doğrulama

Güvenli karşılıkta HTTPS, güvenilir CA ve sunucu adı doğrulaması etkinleştirilecek. Aynı güvenilmeyen sunucu tekrar denendiğinde OTA'nın reddedildiği ve bilinen iyi firmware'in çalışmaya devam ettiği seri logla kanıtlanacak.
