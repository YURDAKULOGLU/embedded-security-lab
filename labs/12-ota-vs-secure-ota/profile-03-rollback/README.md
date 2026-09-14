# Profil 3 — Geçerli İmza, Eksik Anti-Rollback

## Öğrenme sorusu

İki firmware de doğru anahtarla imzalıysa fakat eski sürüm bilinen bir açık içeriyorsa yalnız imza doğrulaması cihazı korur mu?

## Güvensiz profil

- `v1`: Eski, geçerli imzalı ve bilerek açık marker'ı taşıyan image
- `v2`: Yeni, geçerli imzalı ve düzeltilmiş image
- Anti-rollback enforcement kapalı
- Deney: `v2` çalışırken `v1` OTA ile sunulur
- Beklenen sonuç: İmza geçerli olduğu için downgrade kabul edilir

## Secure OTA kapatması

- Firmware security version artırılır.
- Minimum kabul edilen security version uygulanır.
- Aynı eski ve geçerli imzalı image tekrar sunulur.
- Beklenen sonuç: İmza doğru olsa bile sürüm politikası nedeniyle ret

İlk uygulama QEMU veya geri döndürülebilir host modelinde yapılır. Gerçek `SECURE_VERSION` eFuse ilerletmesi ayrı güvenlik kapısıdır.
