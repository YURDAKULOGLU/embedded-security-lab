# Lab 12.00 — OTA A/B Partition Haritası

## Problem

Çalışan uygulamanın üzerine doğrudan yazmak, güncelleme yarıda kesildiğinde cihazı açılmaz hâle getirebilir. OTA için ayrı application slotları ve boot seçimini tutan metadata gerekir.

## Hipotez

Geçerli iki-slotlu tablo ESP-IDF tarafından kabul edilecek; birbiriyle çakışan iki application partition içeren tablo reddedilecektir.

## Deney

```powershell
.\Run-Lab.ps1
```

Betik:

1. `partitions.csv` dosyasını binary partition table'a çevirir.
2. Binary tabloyu tekrar metne çevirerek adresleri doğrular.
3. Bilerek çakışan test tablosunu derlemeyi dener.
4. Çakışan tablonun non-zero exit code ile reddedilmesini bekler.
5. Sonuçları Git tarafından yok sayılan `evidence/private/` alanına yazar.

## Beklenen harita

```text
0x009000  nvs
0x00F000  otadata
0x011000  phy_init
0x020000  ota_0 (1.5 MiB)
0x1A0000  ota_1 (1.5 MiB)
```

Bu alt deney donanım kullanmaz ve eFuse/flash değişikliği yapmaz.

Tamamlanan deneyin sonuçları için [LAB_REPORT.md](LAB_REPORT.md) dosyasına bakın.
