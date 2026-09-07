# Lab 04 Raporu — ESP32-C3 Secure Boot V2 Emülasyonu

Tarih: 7 Eylül 2026

Durum: `EMULATOR_VERIFIED`

## Güvenlik sınırı

- Kanıt hedefi: `EMULATOR_VERIFIED`
- Fiziksel karta yazma: Yasak
- Fiziksel eFuse değişikliği: Yok
- QEMU eFuse/flash durumu: Geçici emülatör dosyaları

## Araştırma sorusu

ESP32-C3 Secure Boot V2 yapılandırılmış imzalı bootloader ve uygulama QEMU'da açılırken, içeriği değiştirilmiş uygulama reddedilir mi?

## Deney öncesi tahmin

1. Doğru RSA-3072 anahtarıyla imzalanmış bootloader ve uygulama açılmalıdır.
2. Uygulamanın imzalanmış alanında tek bit değişirse Secure Boot doğrulaması başarısız olmalıdır.
3. Fiziksel kart kullanılmadığı için sonuç `HARDWARE_VERIFIED` olarak işaretlenmemelidir.

## Yapılandırma

- ESP-IDF: 6.0.2
- Hedef: ESP32-C3, minimum revizyon v0.3
- İmza şeması: Secure Boot V2 / RSA-3072 / RSA-PSS / SHA-256
- Flash yapılandırması: 4 MB
- Partition table offset: `0xC000`

Derleme sonucunda oluşan flash yerleşimi:

| Bölüm | Başlangıç | Boyut | Görev |
|---|---:|---:|---|
| Bootloader | `0x00000` | `0xB000` | Uygulamayı seçer ve imzasını doğrular |
| Partition table | `0x0C000` | `0x1000` ayrılmış alan | Flash bölümlerinin adres haritası |
| NVS | `0x0D000` | 24 KiB | Kalıcı anahtar-değer verileri |
| PHY init | `0x13000` | 4 KiB | Radyo fiziksel katman ayarları |
| Factory app | `0x20000` | 1 MiB | İmzalı uygulama firmware'i |

İlk derleme varsayılan `0x8000` partition table adresiyle denendi. Secure Boot kodu, secure padding ve 4 KB signature sector eklendiğinde imzalı bootloader `0xB000` bayta ulaştı. Bu boyut `0x8000` sınırını aştığı için ESP-IDF olası flash çakışmasını önleyerek derlemeyi durdurdu:

```text
Bootloader binary size 0xb000 bytes is too large for partition table offset 0x8000.
```

Varsayılan partition CSV dosyasında bölüm offset'leri boş bırakıldığı için partition table adresi `0xC000` değerine taşındı; sonraki data ve application partition adresleri ESP-IDF tarafından otomatik hesaplandı.

## Derleme ve imza doğrulaması

ESP-IDF hem bootloader'ı hem uygulamayı aynı RSA-3072 özel anahtarıyla imzaladı. Özel anahtar `.private/` altında tutuldu ve Git tarafından yok sayıldı.

| Dosya | Boyut | SHA-256 |
|---|---:|---|
| `bootloader.bin` | 45.056 bayt | `76AC1841AB4C1849290DFF560BBCA44E409E40B3DBD788DFAE7524A941C123BB` |
| `secure_boot_qemu.bin` | 200.704 bayt | `D7B5CD1C17FC57B68168DB39ACA39C161327D18E67801A896720207422E6E514` |
| `partition-table.bin` | 3.072 bayt | `5958A4ABCF64032CDCD411097E9EBE2E227CE5C45558029FDB6EE8064F299648` |

Tablodaki hash'ler Docker içindeki ESP-IDF 6.0.2 ile üretilen ve QEMU deneyinde gerçekten kullanılan dosyalara aittir. Derleme zamanı gibi metadata değişirse kaynak kod aynı olsa bile firmware hash'i değişebilir.

Her iki imza için `espsecure verify-signature` başarılı oldu. İki dosyada bulunan açık anahtar özeti aynıdır:

```text
9f ab 1a ff d4 13 bd 8f e1 34 c0 1e 6d 06 63 82
cb 41 28 9c a8 dd e2 eb 0b d5 b6 a6 bf 6d 8c 9c
```

Bu özet, QEMU'nun sanal eFuse alanına kaydettiği güven kökünün kimliğidir. Fiziksel kartın eFuse alanına yazılmamıştır.

## Pozitif test

İmzalı bootloader, partition table ve imzalı uygulama 4 MiB sanal flash görüntüsünde birleştirildi. QEMU ilk açılışta boş sanal eFuse dosyasını kullandı.

Gözlenen güven zinciri:

1. Bootloader uygulama imzasını RSA-PSS ile doğruladı.
2. Bootloader kendi imzasından açık anahtar özetini hesapladı.
3. Bootloader ve uygulama anahtarlarının eşleştiğini doğruladı.
4. Açık anahtar özeti sanal eFuse'a yazıldı ve sanal Secure Boot etkinleştirildi.
5. Uygulama başlatıldı ve `app_main()` çalıştı.

Seçilmiş kanıt satırları:

```text
secure_boot_v2: Verifying with RSA-PSS...
secure_boot_v2: Signature verified successfully!
secure_boot_v2: Application key(0) matches with bootloader key(0).
secure_boot_v2: Secure boot permanently enabled
main_task: Calling app_main()
SECURE_BOOT_QEMU_APP_STARTED
```

Buradaki `permanently enabled` yalnız QEMU'nun geçici `qemu_efuse.bin` dosyası için kalıcıdır; gerçek ESP32-C3 kartına uygulanmamıştır.

## Negatif test

### Negatif test A — uygulama verisinde tek bit değişikliği

Pozitif test flash görüntüsünün kopyasında, uygulamanın imzalanmış alanındaki `0x4F000` flash adresinde bir bit `0x00 → 0x01` olarak değiştirildi. Sanal eFuse kopyası değiştirilmedi.

```text
esp_image: Checksum failed. Calculated 0x75 read 0x74
boot: Factory app partition is not bootable
boot: No bootable app partitions in the partition table
```

Uygulamanın ESP görüntü checksum'u hatayı imza kontrolünden önce yakaladı. `app_main()` çalışmadı. Bu test veri bütünlüğü katmanının bozulmayı engellediğini gösterir; tek başına dijital imza davranışını kanıtlamaz.

### Negatif test B — yalnız RSA imzasında tek bit değişikliği

Uygulama içeriği ve checksum'u değiştirilmeden, uygulama signature block içindeki RSA imza baytında `0x5032C` flash adresinde bir bit `0xD6 → 0xD7` olarak değiştirildi. Signature block yapısının geçerli kalması için blok CRC32 değeri güncellendi. Özel anahtarla yeni imza üretilmedi.

```text
esp_image: Verifying image signature...
secure_boot_v2: Verifying with RSA-PSS...
Signature Check Failed
Sig block 0 signature verification failed
esp_image: Secure boot signature verification failed
esp_image: image valid, signature bad
boot: Factory app partition is not bootable
boot: No bootable app partitions in the partition table
```

`image valid, signature bad` satırı, sıradan görüntü yapısının geçerli olmasına rağmen kriptografik kimlik doğrulamasının başarısız olduğunu gösterir. `app_main()` çalışmadı.

## Sonuç

Deney öncesi tahmin doğrulandı: doğru anahtarla imzalanmış bootloader ve uygulama çalıştı; uygulama verisi veya RSA imzası değiştirildiğinde uygulama reddedildi.

| Senaryo | Bootloader doğrulandı | Uygulama çalıştı | Sonuç |
|---|---|---|---|
| Geçerli imzalı görüntü | Evet | Evet | Kabul |
| Uygulama verisinde tek bit bozuk | Evet | Hayır | Checksum katmanında ret |
| RSA imzasında tek bit bozuk | Evet | Hayır | Secure Boot imza katmanında ret |

Bu deney `EMULATOR_VERIFIED` seviyesindedir. Fiziksel ESP32-C3 üzerinde Secure Boot aktivasyonu, eFuse yazımı veya güvenli indirme/JTAG kapatma işlemi yapılmadı. Dolayısıyla sonuç `HARDWARE_VERIFIED` değildir.

## Öğrenilen kavramlar

- **Secure Boot:** Çipin yalnız yetkili anahtarla imzalanmış kodu çalıştırması.
- **Root of Trust:** Güven kararının başladığı, burada ROM ve eFuse'taki açık anahtar özetiyle kurulan temel.
- **Chain of Trust:** ROM'un bootloader'ı, bootloader'ın uygulamayı doğruladığı güven zinciri.
- **RSA-PSS:** RSA ile dijital imza üretmek ve doğrulamak için kullanılan güvenli dolgulama şeması.
- **SHA-256 digest:** Veriyi veya açık anahtarı temsil eden 256 bitlik tek yönlü özet.
- **Checksum:** Kazara bozulmayı hızlı bulur; saldırgana karşı kimlik doğrulaması sağlamaz.
- **CRC32:** Burada signature block yapısının bozulup bozulmadığını kontrol eden 32 bitlik hata tespit değeri.
- **eFuse:** Gerçek çipte bir kez programlanan kalıcı güvenlik bitleri; QEMU'da dosyayla taklit edildi.
- **Provisioning:** Anahtar özetlerinin ve güvenlik ayarlarının kontrollü biçimde cihaza yüklenmesi.
- **Negative test:** Sistemin geçersiz girdiyi beklendiği gibi reddettiğini kanıtlayan deney.

## Sunumda söylenebilecek kısa özet

“Secure Boot'u yalnız teorik olarak incelemedim. ESP32-C3 için RSA-3072 ile imzalı bootloader ve uygulama ürettim. Önce `espsecure` ile iki imzayı doğruladım, sonra QEMU'da ROM–bootloader–uygulama güven zincirini çalıştırdım. Geçerli görüntü açıldı. Uygulama verisinde tek bit değişince checksum katmanı, yalnız RSA imzasında tek bit değişince Secure Boot katmanı uygulamayı reddetti. Gerçek kartın eFuse'larına henüz dokunmadım; o adımı geri döndürülemez olduğu için ayrı bir provisioning planıyla yapacağım.”
