# OTA Saldırı ve Kanıt Matrisi

Bu tablo deneyler tamamlandıkça güncellenecektir. `PLANLANDI` bir güvenlik iddiası değildir.

| Saldırı sınıfı | Profil 1: Güvensiz kanal | Profil 2: Korumasız cihaz | Profil 3: Rollback |
|---|---|---|---|
| Kanal / sahte sunucu | PLANLANDI | Uygulanamaz | Uygulanamaz |
| Image bütünlüğü | PLANLANDI | PLANLANDI | PLANLANDI |
| Image kimliği | PLANLANDI | PLANLANDI | Geçerli imza varsayılır |
| Downgrade | Uygulanamaz | Uygulanamaz | PLANLANDI |
| Flash gizliliği | Uygulanamaz | Lab 02 başlangıç kanıtı mevcut | Uygulanamaz |

## Kanıt etiketleri

- `HOST_VERIFIED`: Bilgisayar üzerinde çalışan test veya model.
- `EMULATOR_VERIFIED`: QEMU üzerinde çalışan boot/update davranışı.
- `HARDWARE_VERIFIED`: Fiziksel ESP32-C3 üzerinde tekrar üretilebilir sonuç.
- `SOURCE_REVIEWED`: Kaynak veya doküman incelendi; çalıştırılmış deney değildir.
