# Lab 12.00 Raporu — OTA A/B Partition Haritası

Tarih: 14 Eylül 2026
Çalıştırma kimliği: `20260914-110304`
Durum: `HOST_VERIFIED`

## Problem

Çalışan firmware'in üzerine doğrudan yazılan bir güncelleme, güç veya bağlantı kesilirse cihazı açılmaz hâle getirebilir. ESP-IDF OTA akışında yeni image'ın ayrı bir application partition'a yazılacağı ve boot seçiminin ayrı metadata ile tutulacağı bir flash haritası gerekir.

## Hipotez

1. Bir `otadata` ve iki ayrı application slotu içeren 4 MB tablo kabul edilecektir.
2. İkinci OTA slotu birinci slotun alanına girerse ESP-IDF tabloyu reddedecektir.

## Deney

ESP-IDF 6.0.2 `gen_esp32part.py` aracıyla `partitions.csv` binary tabloya çevrildi. Binary tekrar metne çevrilerek adresler doğrulandı. Ardından yalnız test amacıyla hazırlanmış çakışan tablo aynı doğrulamadan geçirildi.

Bu deneyde fiziksel karta erişilmedi; flash veya eFuse değişikliği yapılmadı.

## Pozitif test

Üretilen tablo:

| Partition | Başlangıç | Boyut | Görev |
|---|---:|---:|---|
| `nvs` | `0x009000` | 24 KiB | Kalıcı anahtar-değer verileri |
| `otadata` | `0x00F000` | 8 KiB | Boot edilecek OTA slotunun durum bilgisi |
| `phy_init` | `0x011000` | 4 KiB | Radyo fiziksel katman ayarları |
| `ota_0` | `0x020000` | 1.5 MiB | Birinci application slotu |
| `ota_1` | `0x1A0000` | 1.5 MiB | İkinci application slotu |

Son partition `0x320000` adresinde biter. 4 MB flash içinde sonrasında 917.504 bayt, yani 896 KiB kullanılmayan alan kalır.

Binary partition table SHA-256 değeri:

```text
10AEED40B64753A28AD4B3CC8EDD226DE68083313907E52869F602E98384D05B
```

## Negatif test

Test tablosunda `ota_0` partition'ı `0x1A0000` adresinde bitmesine rağmen `ota_1` bilerek `0x190000` adresinden başlatıldı. Böylece iki application slotu 64 KiB çakıştı.

ESP-IDF sonucu:

```text
CSV Error at line 7: Partitions overlap.
Partition sets offset 0x190000.
Previous partition ends 0x1a0000
```

Araç `exit code 2` üretti ve bozuk tabloyu reddetti.

## Gözlem ve teşhis

`otadata`, uygulama binary'si değildir. Bootloader'ın `ota_0` veya `ota_1` arasından hangisini seçmesi gerektiğini tutan metadata alanıdır. Yeni firmware çalışan slotun üzerine değil pasif slota yazılır; indirme ve doğrulama tamamlandıktan sonra boot seçimi değiştirilir.

Partition çakışması kabul edilseydi bir image diğer image'ın baytlarını ezebilirdi. ESP-IDF'in build-time doğrulaması bu hatalı flash haritasını cihaz programlanmadan önce durdurdu.

## Sonuç

İki hipotez de doğrulandı. Geçerli A/B OTA haritası üretildi ve tekrar ayrıştırıldı. Bilerek çakışan harita reddedildi. Sonraki aşamada `ota_0` üzerinde çalışan bir istemci, yeni image'ı `ota_1` slotuna indirecek şekilde hazırlanabilir.

## Kendi cümlemle açıklama

“OTA sırasında çalışan uygulamanın üzerine yazmak yerine ikinci bir application slotu kullanılır. Yeni image pasif slota yazılır. `otadata`, bootloader'ın sonraki açılışta hangi slotu seçeceğini belirtir. Böylece yarım kalan bir indirme çalışan firmware'i doğrudan bozmaz.”
