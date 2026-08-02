# Donanım Güvenlik Kapısı

## Kesinlikle otomatik çalıştırılmayacak işlemler

- eFuse yakma
- Secure Boot kalıcı etkinleştirme
- Flash Encryption release mode etkinleştirme
- JTAG'i kalıcı kapatma
- UART download mode'u kalıcı kapatma
- Anahtar iptal bitlerini yazma

## Fiziksel Secure Boot öncesi kontrol listesi

- [ ] Kartın tam SoC modeli doğrulandı.
- [ ] Çip revizyonu doğrulandı.
- [ ] ESP-IDF sürümü kaydedildi.
- [ ] Mevcut eFuse özeti salt okunur komutla kaydedildi.
- [ ] Kartın deney için ayrılmış olduğu doğrulandı.
- [ ] Özel anahtar güvenli konumda ve yedekli.
- [ ] Özel anahtar Git tarafından izlenmiyor.
- [ ] İmzalı bootloader yerel olarak doğrulandı.
- [ ] İmzalı uygulama yerel olarak doğrulandı.
- [ ] İmzasız/değiştirilmiş uygulama emülatörde reddedildi.
- [ ] UART/JTAG etkileri öğrenci tarafından açıklandı.
- [ ] Güç ve USB bağlantısı kararlı.
- [ ] Kalıcı işlem için açık insan onayı alındı.

Kontrol listesindeki tek bir madde bile eksikse eFuse yazılmaz.
