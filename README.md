# Cyber Quanta Embedded Security Lab

Bu depo, Cyber Quanta stajına hazırlanırken gömülü sistemler ve cihaz güvenliğini deneylerle öğrenmek için oluşturulmuş kişisel laboratuvardır. Amaç komutları ezberlemek değil; bir sistemin davranışını önceden tahmin etmek, ölçmek, bilinçli olarak bozmak ve sonucu teknik olarak açıklayabilmektir.

> Bu, kişisel bir eğitim ve deney deposudur; Cyber Quanta'nın resmî yazılımı veya resmî dokümantasyonu değildir.

## İçindekiler

- [Öğrenme sözleşmesi](#öğrenme-sözleşmesi)
- [Laboratuvar yöntemi](#laboratuvar-yöntemi)
- [Kurulu teknoloji yığını](#kurulu-teknoloji-yığını)
- [Başlangıç](#başlangıç)
- [Laboratuvar sırası](#laboratuvar-sırası)
- [Başarı ölçütleri](#başarı-ölçütleri)
- [Güvenlik kuralları](#güvenlik-kuralları)
- [Dizin yapısı](#dizin-yapısı)
- [Sorun giderme](#sorun-giderme)

## Öğrenme sözleşmesi

Bu depoda asistan doğrudan çözüm üretmez. Her deney şu kurallarla yürütülür:

1. Öğrenci deneyden önce tahminini yazar.
2. Öğrenci ilk uygulamayı kendisi yapar.
3. Bir hata oluştuğunda öğrenci önce gözlemini ve olası nedenini kaydeder.
4. Yardım gerektiğinde ipuçları küçükten büyüğe verilir.
5. Tam çözüm ancak deneme ve gerekçelendirme sonrasında gösterilir.
6. Her laboratuvar ölçülebilir kanıtla kapanır.
7. Konu 48 saat veya daha sonra kısa bir tekrar göreviyle yeniden sınanır.
8. Yeni bir teknik terim ilk kullanımında Türkçe karşılığı, görevi, bulunduğu yer ve ilişkili olduğu parçalarla birlikte açıklanır.
9. Açıklanmamış bir terim üzerine deney kurulmaz; öğrenci terimi kendi cümlesiyle ifade edebildikten sonra devam edilir.

Bir komutun çalışması öğrenme kanıtı değildir. Komutun neyi değiştirdiğini ve neden o sonucu ürettiğini açıklamak gerekir.

## Laboratuvar yöntemi

Her laboratuvar aşağıdaki döngüyü kullanır:

```text
Problem → Tahmin → Deney → Gözlem → Bozma → Teşhis → Açıklama → Tekrar
```

Her deney raporunda şu alanlar bulunur:

- Araştırma sorusu
- Deney öncesi tahmin
- Kullanılan donanım ve yazılım sürümleri
- Uygulanan işlem
- Ham çıktı veya ekran görüntüsü
- Beklenen ve gerçekleşen sonuç arasındaki fark
- Teknik açıklama
- Yeni soru

## Kurulu teknoloji yığını

- Windows geliştirme ortamı
- ESP-IDF 6.0.2
- Xtensa ve RISC-V ESP derleyicileri
- CMake ve Ninja
- OpenOCD ve GDB
- esptool ve espefuse
- VS Code ESP-IDF eklentisi
- Docker Desktop
- QEMU Xtensa ve RISC-V: resmî ESP-IDF Docker ortamında doğrulandı

ESP-IDF kaynakları `C:\Espressif\frameworks\esp-idf-v6.0.2`, araçlar ise `C:\Espressif\tools` altında tutulur.

## Başlangıç

### 1. ESP-IDF terminalini aç

Proje kökünde PowerShell açıp şu komutu çalıştır:

```powershell
. .\scripts\Enter-EspIdf.ps1
```

Bu işlem yalnızca açık terminalin ortamını ESP-IDF için hazırlar.

### 2. Ortam kontrolünü çalıştır

```powershell
.\scripts\Check-Environment.ps1
```

Kontrolün ESP-IDF, Python, CMake, Ninja ve derleyici sürümlerini göstermesi beklenir. Kart bağlı değilse seri port kontrolünün başarısız olması normaldir.

Docker ve QEMU ortamını ayrıca doğrulamak için:

```powershell
.\scripts\Check-Docker.ps1
```

### 3. İlk laboratuvara geç

[`labs/00-environment`](labs/00-environment/README.md) içindeki görevleri tamamla. Komutların beklenen çıktıları bilerek verilmemiştir; önce tahmin yazılmalıdır.

## Laboratuvar sırası

| No | Laboratuvar | Öğrenme hedefi | Donanım riski |
|---:|---|---|---|
| 00 | Ortam doğrulama | Araç zinciri ve tekrar üretilebilir derleme | Yok |
| 01 | Çip keşfi | Seri port, ROM boot logu, çip modeli ve revizyon | Çok düşük |
| 02 | Boot zinciri | ROM, ikinci aşama bootloader, partition ve uygulama | Düşük |
| 03 | Firmware imzalama | Hash, açık/özel anahtar ve imza doğrulama | Yok |
| 04 | Secure Boot emülasyonu | İmzalı ve değiştirilmiş görüntü davranışları | Yok |
| 05 | Donanım Secure Boot | eFuse, güven kökü ve gerçek boot doğrulaması | Yüksek |

05 numaralı laboratuvar, önceki laboratuvarlar tamamlanmadan ve açık onay verilmeden çalıştırılmaz.

Sonraki modüller mikrodenetleyici çevre birimleri, haberleşme protokolleri, FreeRTOS, güvenli OTA, PKI/mTLS, HSM/secure element ve gömülü Linux konularını kapsayacaktır.

## Başarı ölçütleri

Bir laboratuvar ancak aşağıdaki koşulların tamamı sağlanırsa biter:

- Deney öncesi tahmin yazılmıştır.
- Komut ve ham çıktılar kaydedilmiştir.
- En az bir hata veya olumsuz durum incelenmiştir.
- Sonuç kendi cümlelerinle açıklanmıştır.
- Açıklama, kullanılan kavramlar arasındaki neden-sonuç ilişkisini içerir.
- Kontrol sorularına notlara bakmadan cevap verilebilmiştir.
- Tekrar görevi daha sonra yeniden yapılmıştır.

Ayrıntılı değerlendirme ölçütleri [`docs/MASTERY.md`](docs/MASTERY.md) dosyasındadır.

## Güvenlik kuralları

Secure Boot ve flash encryption deneyleri kalıcı eFuse değişiklikleri içerebilir.

- `espefuse burn_*` içeren hiçbir komut kendiliğinden çalıştırılmaz.
- eFuse yazmadan önce çip modeli ve revizyonu iki bağımsız yöntemle doğrulanır.
- eFuse özeti deneyden önce kaydedilir.
- İmzalama özel anahtarları depoya eklenmez.
- İlk fiziksel Secure Boot deneyi üretim cihazında yapılmaz.
- Güç ve USB bağlantısı kararlı değilse yazma işlemi başlatılmaz.
- JTAG ve UART download mode etkileri anlaşılmadan güvenlik biti etkinleştirilmez.

Tam güvenlik kapısı [`docs/SAFETY.md`](docs/SAFETY.md) dosyasındadır.

## Dizin yapısı

```text
cyber-quanta-embedded-security-lab/
├── docs/                 # Yol haritası, ustalık ve güvenlik kuralları
├── evidence/             # Seri logları, hash'ler ve deney kanıtları
├── labs/                 # Sıralı deneyler ve öğrenci raporları
├── notes/                # Konulara göre düzenlenmiş teori notları
├── scripts/              # Güvenli ortam ve doğrulama yardımcıları
├── .gitignore            # Anahtar ve derleme ürünlerini dışarıda tutar
└── README.md             # Laboratuvarın giriş noktası
```

## Sorun giderme

### `idf.py` bulunamıyor

Önce aynı terminalde ortam betiğini çalıştır:

```powershell
. .\scripts\Enter-EspIdf.ps1
idf.py --version
```

### Kart seri portlarda görünmüyor

- USB kablosunun yalnızca şarj kablosu olmadığını kontrol et.
- Başka bir USB portu dene.
- Kart üzerindeki USB-UART dönüştürücünün modelini belirle.
- Kartı çıkarıp takmadan önce ve sonra port listesini karşılaştır.
- Rastgele sürücü kurmadan önce donanım kimliğini kaydet.

### Derleme eski ayarlarla davranıyor

Önce hatanın `sdkconfig` kaynaklı olup olmadığını incele. Temizlik komutlarını nedeni anlaşılmadan çalıştırma; mevcut yapılandırma deney kanıtı olabilir.

### eFuse komutu isteniyor

Dur. [`docs/SAFETY.md`](docs/SAFETY.md) kontrol listesi tamamlanmadan hiçbir kalıcı yazma komutu çalıştırılmaz.
