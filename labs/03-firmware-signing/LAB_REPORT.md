# Lab 03 Raporu — Gerçek Firmware İmzalama

## Durum

- Kanıt seviyesi: `HOST_VERIFIED`
- Donanım gerekli mi?: Hayır
- eFuse işlemi var mı?: Hayır
- Deney aracı: ESP-IDF `espsecure`

## Araştırma sorusu

Yalnızca hash kontrolü yerine dijital imza kullanıldığında değiştirilmiş veya yetkisiz anahtarla hazırlanmış firmware ayırt edilebilir mi?

## Deney öncesi tahmin

1. Doğru private key ile imzalanan firmware, karşılık gelen public key ile doğrulanmalıdır.
2. İmzadan sonra firmware'in bir baytı değiştirilirse doğrulama başarısız olmalıdır.
3. İmza değiştirilmemiş olsa bile başka bir public key ile doğrulama başarısız olmalıdır.

## Terimler

- **Private key (özel anahtar):** İmza üretir ve gizli tutulur.
- **Public key (açık anahtar):** İmzayı doğrular; private key'i açığa çıkarmaz.
- **SHA-256:** Firmware içeriğinden 256 bitlik özet üretir.
- **RSA-PSS:** RSA tabanlı dijital imza şemasıdır.
- **Signature block:** İmzalı image sonuna eklenen doğrulama bilgileridir.
- **Tamper:** Bir veriye izinsiz müdahale edilmesidir.

## Uygulanan işlem

1. ESP32-C3 için daha önce derlenen `chip_discovery.bin` kopyalandı.
2. Secure Boot V2 için RSA-3072 geliştirme anahtarı üretildi.
3. Anahtardan public doğrulama anahtarı çıkarıldı.
4. Firmware imzalandı.
5. İmza doğru public key ile doğrulandı.
6. İmzalı firmware'in 100. baytındaki tek bit değiştirildi.
7. Değiştirilmiş firmware yeniden doğrulandı.
8. Ayrı üretilmiş yanlış anahtarla orijinal imza doğrulandı.

## Sonuçlar

Deney kimliği: `20260907-131551`

| Örnek | Boyut | SHA-256 | Doğrulama sonucu |
|---|---:|---|---|
| İmzasız kaynak firmware | 142.048 bayt | `AA0DF8D2B...3602C012` | Deney girdisi |
| Doğru anahtarla imzalanmış firmware | 147.456 bayt | `D67279CD0...27CC93A2` | Başarılı, çıkış kodu `0` |
| 100. baytında tek bit değiştirilmiş firmware | 147.456 bayt | `072FDCC68...42AE5AE1` | Reddedildi, çıkış kodu `2` |
| Doğru imza + yanlış public key | 147.456 bayt | `D67279CD0...27CC93A2` | Reddedildi, çıkış kodu `2` |

İmzalama sırasında `espsecure`, uygulamaya 1.312 bayt secure padding ekledi. İmzalanan içerik 143.360 bayta hizalandı ve sonuna 4 KB signature sector eklenerek toplam boyut 147.456 bayt oldu.

Doğru anahtar testi:

```text
Signature block 0 is valid (RSA).
Signature block 0 verification successful using the supplied key (RSA).
```

Tek bit değiştirme testi:

```text
Signature block image digest does not match the actual image digest.
```

Yanlış anahtar testi:

```text
Signature block 0 is not signed by the supplied key.
Signature could not be verified with the provided key.
```

Signature block içindeki public-key digest:

```text
2b 8a f7 d2 0a 34 93 de f0 27 a0 c6 80 41 6b dc
c7 3b da ec e6 a7 38 c4 1f 23 3e a6 64 fd c9 27
```

## Ne kanıtlandı?

- Firmware'in içeriği imzadan sonra değiştiğinde SHA-256 özeti artık signature block içindeki özetle eşleşmedi ve doğrulama başarısız oldu.
- Firmware değiştirilmemiş olsa bile imzayı üreten private key'e karşılık gelmeyen public key doğrulama yapamadı.
- Yalnız bütünlük değil, imzayı atan anahtara bağlı authenticity kontrolü de gerçekleştirildi.
- Private key dosyaları `evidence/private/` altında tutuldu ve Git tarafından yok sayıldığı doğrulandı.

## Ne kanıtlanmadı?

- ESP32-C3 ROM'unun bootloader imzasını doğrulaması
- eFuse içindeki public-key digest davranışı
- Donanım üzerinde imzasız firmware'in boot sırasında reddedilmesi
- Secure Boot sonrası UART/JTAG kısıtları

Bu maddeler fiziksel kart olmadan `HARDWARE_PENDING` olarak kalır.
