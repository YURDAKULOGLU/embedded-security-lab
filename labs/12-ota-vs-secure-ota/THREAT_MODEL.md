# OTA Güncelleme Yolu Tehdit Modeli

## Sistem sınırı

```text
Firmware üreticisi
  ↓ image + metadata
OTA sunucusu
  ↓ HTTP veya HTTPS
Yerel ağ / internet
  ↓
ESP32-C3 OTA istemcisi
  ↓
Pasif OTA slotu
  ↓ otadata seçimi
Bootloader
  ↓
Yeni uygulama
```

## Korunan varlıklar

| Varlık | Neden önemlidir? | Başarısızlık etkisi |
|---|---|---|
| Firmware | Cihaz davranışını belirler | Saldırgan cihaz kontrolünü alabilir |
| İmzalama private key'i | Yetkili firmware üretir | Saldırgan geçerli görünen image imzalayabilir |
| OTA sunucu kimliği | Doğru kaynağı gösterir | Cihaz sahte sunucuya bağlanabilir |
| Firmware bütünlüğü | Aktarımın değişmediğini gösterir | Ağdaki image değiştirilebilir |
| Güvenlik sürümü | Eski açıkların geri gelmesini önler | Geçerli imzalı eski sürüm yüklenebilir |
| Cihazdaki sırlar | Ağ ve servis erişimi sağlayabilir | Flash okumasıyla sızabilir |
| Known-good image | Kurtarma yoludur | Hatalı güncelleme cihazı çalışamaz hâle getirebilir |

## Saldırgan modelleri

| Saldırgan | Yeteneği | İlgili profil |
|---|---|---|
| Aynı ağdaki saldırgan | Trafiği yönlendirebilir veya sahte sunucu sunabilir | Profil 1 |
| OTA sunucusunu ele geçiren saldırgan | Farklı image servis edebilir | Profil 1 ve 3 |
| Fiziksel erişimli saldırgan | UART üzerinden flash okuyabilir/yazabilir | Profil 2 |
| Eski geçerli image'a sahip saldırgan | Downgrade deneyebilir | Profil 3 |

## Beş kontrol noktası

| Saldırı sınıfı | Sorulan soru | Güvenlik kontrolü |
|---|---|---|
| Kanal | Doğru sunucuyla mı konuşuyoruz? | TLS sertifika ve hostname doğrulaması |
| Bütünlük | Image aktarım sırasında değişti mi? | Kriptografik hash ve imza |
| Kimlik | Image yetkili üreticiden mi geldi? | Dijital imza ve Secure Boot |
| Geri alma | Image geçerli ama yasaklanmış kadar eski mi? | Anti-rollback / security version |
| Gizlilik | Flash okunduğunda kod ve sırlar görünüyor mu? | Flash Encryption ve sır yönetimi |

## Güven varsayımları

- Geliştirme bilgisayarı ve private key saklama alanı güvenilirdir.
- Deney OTA sunucusu kullanıcı kontrolündedir.
- Gerçek internet hedeflerine saldırı yapılmaz.
- Deney firmware'inde yalnız sahte sırlar bulunur.
- ESP32-C3 ROM'u başlangıçtaki değiştirilemez kod kabul edilir.

## İlk profil için iddia

TLS sunucu doğrulaması yapılmayan veya düz HTTP kullanan bir OTA istemcisi, geçerli ESP32 application formatındaki sahte bir image'ı kaynağını doğrulamadan kabul edebilir. Secure Boot da kapalıysa bootloader bu image'ı çalıştırabilir.

## İlk profil için başarı kriterleri

1. Güvensiz istemci sahte sunucudan image indirir ve pasif OTA slotuna yazar.
2. Yeniden başladıktan sonra sahte firmware marker'ı seri logda görülür.
3. TLS doğrulaması açıldıktan sonra aynı sahte sunucu reddedilir.
4. Reddedilen denemede çalışan known-good firmware korunur.
