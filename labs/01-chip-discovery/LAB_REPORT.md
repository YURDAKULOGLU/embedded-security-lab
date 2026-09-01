# Lab 01 Raporu — Çipi Keşfet

## Araştırma sorusu

Derlediğimiz firmware flash belleğe yazıldıktan sonra güç kesilip geri geldiğinde yeniden çalışır mı?

## Deney öncesi tahminim

Çalışır. Çünkü derlenen makine kodu, elektrik kesilince silinmeyen flash belleğe yazılır.

## Donanım

- Kart: ESP32-C3
- Port: COM8
- Bağlantı: USB-Serial/JTAG

## Kaynak koddan karta giden yol

Henüz kendi cümlelerimle tamamlanmadı.

## Derleme gözlemim

- `idf.py set-target esp32c3` sonrasında `idf.py build` başarıyla tamamlandı.
- Fiziksel kartta 4 MB flash bulunmasına rağmen varsayılan proje yapılandırması `--flash-size 2MB` üretti.
- Bu aşamada karta veri yazılmadı; yalnızca bilgisayarda derleme çıktıları üretildi.

| Dosya | Boyut | SHA-256 |
|---|---:|---|
| `chip_discovery.elf` | 3.640.984 bayt | `B117335FF115E7C8F097D5EA3590C19A97EA025DC4714008E462277394E6C543` |
| `chip_discovery.bin` | 142.048 bayt | `AA0DF8D2B0C992125E80F37B837F626312D5E29B7257E5103E2605793602C012` |
| `chip_discovery.map` | 2.913.281 bayt | `F2803D1A983AFB2FE32255739FD8A67AECD112482CB544D0A10847EA1E861D8F` |
| `bootloader.bin` | 21.088 bayt | `1210590DC889EBD82089BE509883DC4A94F2D9705D6C9917446A78BC1FD87EA0` |
| `partition-table.bin` | 3.072 bayt | `7F00B6C042A89B15B0CAC534F82ED988CAF29278FF5700B0C511EB1B5BB7C820` |

## Flashlama gözlemim

Henüz deney yapılmadı.

## Güç kesme deneyi

Henüz deney yapılmadı.

## Sonuç

Henüz deney yapılmadı.
