# Lab 01 — Çipi Keşfet

Kart ESP32-C3 ve `COM8` olarak doğrulandı. Bu laboratuvarda küçük bir firmware derlenecek, normal şekilde flashlanacak ve seri çıktı incelenecektir.

## Proje dosyaları

- `firmware/CMakeLists.txt`: ESP-IDF projesini tanımlar.
- `firmware/main/CMakeLists.txt`: Derlenecek C kaynak dosyasını bildirir.
- `firmware/main/main.c`: Kartta çalışacak kaynak koddur.
- `LAB_REPORT.md`: Tahmin, gözlem ve teknik açıklamalar burada tutulur.

## Deney sırası

1. Kaynak kodu oku ve ekrana kaç satır yazılacağını tahmin et.
2. ESP-IDF ortamını aç.
3. Hedefi `esp32c3` olarak seç.
4. Firmware'i derle.
5. Üretilen `.elf` ve `.bin` dosyalarını incele.
6. Firmware'i `COM8` üzerinden karta yaz.
7. Seri monitörde çıktıyı gözle.
8. USB'yi çıkarıp yeniden takarak kalıcılık tahminini test et.

Bu laboratuvarda eFuse yazılmaz ve Secure Boot etkinleştirilmez.
