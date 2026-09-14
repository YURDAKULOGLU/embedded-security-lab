# Lab 02 Raporu — Boot Zinciri ve Flash Read-Back

Tarih: 7 Eylül 2026
Çalıştırma kimliği: `20260907-150554`
Durum: `HARDWARE_READBACK_VERIFIED`

## Araştırma sorusu

ESP32-C3 üzerindeki bootloader, partition table ve uygulama gerçekten beklenen flash adreslerinde mi ve karttaki baytlar yerel build çıktılarıyla aynı mı?

## Güvenlik sınırı

- Cihaz işlemleri: Yalnız flash okuma
- Flash yazma veya silme: Yok
- eFuse yazma: Yok
- Secure Boot aktivasyonu: Yok
- Ham kanıtlar: Git tarafından yok sayılan `evidence/private/` dizininde
- Public raporda cihaz MAC adresi: Yok

## Deney öncesi tahmin

1. Partition table `0x8000` adresinden okunabilmelidir.
2. Tabloda factory application başlangıcı `0x10000` görünmelidir.
3. Karttan okunan bootloader, partition table ve application hash'leri build dosyalarıyla eşleşmelidir.
4. Partition table'ın yalnız yerel kopyasında tek bit değişirse MD5 doğrulaması başarısız olmalıdır.

## Kullanılan kavramlar

- **Offset:** Bir verinin flash bellek içindeki başlangıç adresi.
- **Read-back / flash dump:** Cihazdaki flash baytlarını değiştirmeden bilgisayara okuma işlemi.
- **Binary:** İşlemcinin kullandığı ham makine kodu veya veri dosyası.
- **SHA-256:** İki büyük binary'nin aynı olup olmadığını 256 bitlik özetleri üzerinden karşılaştırmak için kullanılan kriptografik hash.
- **MD5 partition checksum:** ESP-IDF partition table içeriğinde bozulma olup olmadığını tespit eden bütünlük değeri. Bu deneyde dijital imza veya kimlik doğrulama amacıyla kullanılmamıştır.
- **Parser:** Binary partition table'ı okuyup insan tarafından anlaşılabilir satırlara çeviren araç.

## Karttan doğrulanan flash haritası

Partition table `0x8000` adresinden salt-okunur olarak alındı ve ESP-IDF aracıyla ayrıştırıldı:

| Etiket | Tür | Başlangıç | Boyut | Amaç |
|---|---|---:|---:|---|
| `nvs` | Data / NVS | `0x9000` | 24 KiB | Kalıcı anahtar-değer verileri |
| `phy_init` | Data / PHY | `0xF000` | 4 KiB | Radyo fiziksel katman ayarları |
| `factory` | App / Factory | `0x10000` | 1 MiB | Çalıştırılan uygulama firmware'i |

Boot zincirinin bu karttaki somut adres akışı:

```text
ROM
  ↓
0x00000 adresindeki ikinci aşama bootloader
  ↓
0x08000 adresindeki partition table
  ↓ tabloda factory app adresi bulunur
0x10000 adresindeki chip_discovery uygulaması
  ↓
ESP-IDF başlangıç işlemleri ve app_main()
```

## Pozitif test — Kart ve build dosyalarının karşılaştırılması

Yerel build dosyalarının tam boyutları kullanılarak aynı sayıda bayt karttan okundu:

| Bileşen | Flash adresi | Okunan boyut | Build SHA-256 | Eşleşme |
|---|---:|---:|---|---|
| Bootloader | `0x00000` | 21.088 bayt | `1210590DC889EBD82089BE509883DC4A94F2D9705D6C9917446A78BC1FD87EA0` | Evet |
| Partition table | `0x08000` | 3.072 bayt | `7F00B6C042A89B15B0CAC534F82ED988CAF29278FF5700B0C511EB1B5BB7C820` | Evet |
| Application | `0x10000` | 142.048 bayt | `AA0DF8D2B0C992125E80F37B837F626312D5E29B7257E5103E2605793602C012` | Evet |

Üç bileşenin read-back SHA-256 değeri kendi build SHA-256 değeriyle birebir aynıdır. Bu sonuç, derlenen dosyaların ilgili flash adreslerinde gerçekten bulunduğunu kanıtlar.

## Negatif test — Partition table kopyasında tek bit değişikliği

Karttaki partition table değiştirilmedi. Bilgisayara alınan kopyanın ilk partition kaydındaki etiket alanında tek bit çevrildi. Değişiklikten sonra parser tekrar çalıştırıldı.

```text
MD5 checksums don't match!
```

Parser çıkış kodu `2` oldu ve bozuk tablo reddedildi. Böylece partition table'ın yalnız adres listesi olmadığı, kendi bütünlük kontrolünü de taşıdığı gözlendi.

## Sonuç

Deney öncesi dört tahmin de doğrulandı:

- Partition table fiziksel karttan `0x8000` adresinde bulundu.
- Factory application adresi tablodan `0x10000` olarak elde edildi.
- Bootloader, partition table ve application karttan geri okunarak build dosyalarıyla SHA-256 üzerinden eşleştirildi.
- Yerel partition table kopyasındaki tek bit değişikliği MD5 kontrolü tarafından reddedildi.

Bu laboratuvar `HARDWARE_READBACK_VERIFIED` seviyesindedir. Kartta gerçek fiziksel flash içeriği incelendi fakat hiçbir veri veya güvenlik biti değiştirilmedi.

## Sunumda söylenebilecek kısa özet

“Boot logundaki adresleri yalnız yorumlamadım. ESP32-C3'ün flash belleğinden bootloader, partition table ve uygulamayı kendi adreslerinden salt-okunur olarak geri aldım. Partition table'dan factory uygulamasının `0x10000` adresinde olduğunu çıkardım. Üç read-back dosyasının SHA-256 değeri build çıktılarıyla birebir eşleşti. Son olarak yalnız yerel partition table kopyasında tek bit değiştirince MD5 bütünlük kontrolünün tabloyu reddettiğini gözlemledim.”
