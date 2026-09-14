# Lab 12 — ESP32-C3 OTA vs Secure OTA

Bu laboratuvar, “OTA çalışıyor” ile “OTA güvenli çalışıyor” arasındaki farkı ESP32-C3 üzerinde önce/sonra deneyleriyle gösterir.

## Hedef donanım ve uyarlama

- Donanım: ESP32-C3 QFN32, revizyon v0.4
- Flash: 4 MB
- Yazılım: ESP-IDF 6.0.2
- Ağ: Yalnız kullanıcıya ait izole laboratuvar ağı

Görevin özgün tarifi klasik ESP32 revizyonlarını referans alır. Bu uygulama ESP32-C3'e uyarlanmıştır. Klasik ESP32 Secure Boot v1/v2 revizyon ayrımları ve klasik ESP32'ye özel CVE sonuçları, ESP32-C3 donanım kanıtı gibi sunulmaz.

## Öğrenme hedefi

Her profil aynı döngüyle işlenir:

```text
Kavramı öğren
  ↓
Saldırı sonucunu tahmin et
  ↓
Güvensiz sistemi çalıştır
  ↓
Aynı saldırıyı uygula
  ↓
Eksik kontrolü teşhis et
  ↓
Secure OTA kontrolünü ekle
  ↓
Aynı saldırının reddedildiğini kanıtla
```

## Profil sırası

1. **Güvensiz kanal:** HTTP veya doğrulanmayan TLS üzerinden sahte OTA sunucusu.
2. **Korumasız cihaz:** Secure Boot ve Flash Encryption kapalıyken flash okuma ve yetkisiz image riski.
3. **Yanlış sürüm politikası:** Geçerli imzalı fakat eski firmware ile downgrade.

## Alt laboratuvarlar

| Sıra | Çalışma | Durum | Kanıt hedefi |
|---:|---|---|---|
| 00 | [`ota-partition-map`](00-ota-partition-map/README.md) | Tamamlandı | `HOST_VERIFIED` |
| 01 | [`insecure-channel`](profile-01-insecure-channel/README.md) | Planlandı | `HARDWARE_VERIFIED` |
| 02 | [`unprotected-device`](profile-02-unprotected-device/README.md) | Planlandı | `HARDWARE_VERIFIED` |
| 03 | [`rollback`](profile-03-rollback/README.md) | Planlandı | Önce `EMULATOR_VERIFIED` |

## Başlangıç belgeleri

- [Tehdit modeli](THREAT_MODEL.md)
- [Kavram notları](LEARNING_NOTES.md)
- [Deney matrisi](EXPERIMENT_MATRIX.md)

## Güvenlik sınırı

- Gerçek parola, API token veya üretim anahtarı kullanılmaz.
- Private signing key Git'e eklenmez.
- Ağ testleri yalnız kullanıcının kendi izole lab ağında yapılır.
- eFuse işlemleri recovery image ve negatif test kapıları tamamlanmadan yapılmaz.
- Klasik ESP32'ye ait zafiyetler ESP32-C3 için doğrulanmış sayılmaz.

## Kaynak temeli

Uygulama, yerel ESP-IDF 6.0.2 dağıtımındaki resmi `examples/system/ota` örnekleri ve `esp_https_ota` bileşeni temel alınarak geliştirilecektir. Dahili görev belgesi bu public repoda yeniden dağıtılmaz.
