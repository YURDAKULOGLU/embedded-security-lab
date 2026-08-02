# Lab 00 — Ortamı Kanıtla

## Araştırma sorusu

Bir ESP32 uygulamasının kaynak koddan flashlanabilir binary dosyasına dönüşebilmesi için hangi araçlar birlikte çalışır?

## Kurallar

- Komut çalıştırmadan önce tahminini `LAB_REPORT.md` içine yaz.
- Çıktıyı okuyup anlamadan sonraki adıma geçme.
- İlk hata mesajını silme; rapora kaydet.

## Görevler

1. ESP-IDF ortamını aç.
2. Ortam kontrol betiğini çalıştır.
3. Bulunan her aracın zincirdeki görevini araştır ve bir cümleyle yaz.
4. ESP-IDF içindeki `hello_world` örneğinin dosya yapısını incele.
5. Hedefi `esp32` seçerek örneği derle.
6. Üretilen `.elf`, `.bin`, `.map` ve partition çıktılarının amaçlarını karşılaştır.
7. Bir kaynak satırını değiştirip yeniden derle; hangi çıktıların değiştiğini hash ile ölç.

## Başarı kanıtı

- Ortam kontrol çıktısı
- Başarılı derleme çıktısı
- Üretilen dosyaların boyutları ve SHA-256 değerleri
- Değişiklik öncesi/sonrası karşılaştırma
- Araç zincirini kendi cümlelerinle anlatan kısa açıklama

Kart bu laboratuvar için gerekli değildir.
