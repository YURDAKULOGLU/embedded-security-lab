# Profil 1 — Güvensiz OTA Kanalı

## Öğrenme sorusu

Cihaz indirdiği firmware'in doğru sunucudan geldiğini doğrulamazsa geçerli formatta fakat yetkisiz bir application image'ı kabul eder mi?

## Önce: bilerek güvensiz profil

- ESP32-C3, 4 MB flash
- İki OTA slotu
- Düz HTTP veya doğrulaması bilerek kapatılmış lab TLS'i
- Secure Boot kapalı
- Flash Encryption kapalı
- Sahte update image marker'ı: `UNTRUSTED_OTA_FIRMWARE_RUNNING`

## Sonra: Secure OTA kapatması

- HTTPS
- Güvenilir CA sertifikası
- Sunucu adı doğrulaması
- Aynı sahte sunucuyla tekrar test
- Beklenen sonuç: TLS doğrulama hatası ve known-good firmware'in korunması

## Kanıtlar

- Normal ve sahte firmware SHA-256 değerleri
- OTA istemci seri logu
- Yerel OTA sunucu istek logu
- Güncelleme öncesi/sonrası çalışan partition
- Sahte firmware marker'ının önce görülmesi, düzeltmeden sonra görülmemesi

## Güvenlik sınırı

İlk uygulamada ARP spoof zorunlu değildir. OTA URL'si kontrollü şekilde kullanıcının kendi sahte lab sunucusuna yönlendirilir. MITM varyantı daha sonra yalnız izole lab ağında uygulanabilir.

## Firmware yapısı

```text
firmware/
├── partitions.csv
├── ota-client/        Bilerek güvensiz HTTP OTA istemcisi
└── untrusted-update/  Açıldığında test marker'ı basan update image
```

İstemci açıldığında çalışan ve pasif partition adreslerini loglar. Ardından HTTP URL'sindeki image'ı indirir. Update image açılırsa `UNTRUSTED_OTA_FIRMWARE_RUNNING` marker'ı görülür.

## Derleme

Gerçek ağ bilgisi olmadan kaynakların derlenebildiğini doğrulamak için:

```powershell
.\Build-Lab.ps1
```

Gerçek donanım deneyi öncesinde Wi-Fi parolası ve yerel sunucu IP'si Git tarafından yok sayılan `.private/` dosyasına yazılır:

```powershell
.\Configure-Private.ps1
.\Build-Lab.ps1 -UsePrivateConfig
```

Private ayarlar ve derlenmiş binary'ler Git'e eklenmez.

Güvenilmeyen firmware'i yerel ağda sunmak için ikinci bir terminalde:

```powershell
.\Start-OtaServer.ps1
```

Bu küçük HTTP sunucusu yalnızca lab bilgisayarındaki `untrusted_update.bin` dosyasını sunar. ESP32-C3 ile bilgisayar aynı izole/test Wi-Fi ağında olmalıdır.

Kaynak ve derleme kanıtları [BUILD_REPORT.md](BUILD_REPORT.md), gerçek kart deneyi ise [HARDWARE_REPORT.md](HARDWARE_REPORT.md) dosyasındadır.

## Tamamlananlar

- İstemci gerçek ESP32-C3 karta flashlandı.
- Yerel HTTP OTA sunucusu çalıştırıldı ve kartın isteği kaydedildi.
- Yetkisiz test image'ı `ota_1` bölümüne yazıldı ve oradan boot edildi.
- `ota_1` flash içeriği geri okunarak sunulan binary ile SHA-256 seviyesinde eşleştiği doğrulandı.

## Sonraki aşama

- HTTPS sertifika doğrulamalı güvenli karşılık henüz eklenmedi.
- Aynı saldırı güvenli profile karşı tekrar denenip reddedildiği kanıtlanacak.
