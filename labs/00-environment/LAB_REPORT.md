# Lab 00 Raporu

## Deney öncesi tahminim

Henüz yazılmadı.
## Ortam bilgileri

- Tarih: 2026-08-08
- ESP-IDF sürümü: v6.0.2
- Python sürümü: 3.12.10
- Hedef çip: ESP32-C3 (QFN32, revizyon v0.4)
- Bağlantı noktası: COM8 (USB-Serial/JTAG)

## Araçların görevleri

| Araç | Benim açıklamam |
|---|---|
| CMake | |
| Ninja | |
| Derleyici | |
| Linker | |
| esptool | |

## Gözlemler

- Windows kartı Espressif USB JTAG/seri aygıtı olarak algıladı.
- `esptool chip-id` kartı ESP32-C3 olarak otomatik tanıdı.
- Kart tek çekirdekli, 160 MHz, Wi-Fi/BLE özellikli ve 4 MB gömülü flash belleğe sahip.
- Bu adımda flash belleğe veya eFuse alanına kalıcı veri yazılmadı.

## Hata ve teşhis

- İlk denemede `IDF_TOOLS_PATH` ayarlanmadığı için ESP-IDF, Python sanal ortamını yanlış dizinde aradı.
- Projenin `Enter-EspIdf.ps1` betiği doğru araç dizinini ayarladıktan sonra bağlantı başarılı oldu.
- Sonuç: Sorun kartta veya USB kablosunda değil, terminalin araç ortamındaydı.

## Çıktı karşılaştırması

| Dosya | İlk SHA-256 | Değişiklik sonrası SHA-256 | Neden değişti? |
|---|---|---|---|
| ELF | | | |
| BIN | | | |
| MAP | | | |

## Sonuç

Henüz yazılmadı.

## Yeni sorum

Henüz yazılmadı.
