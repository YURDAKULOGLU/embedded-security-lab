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
