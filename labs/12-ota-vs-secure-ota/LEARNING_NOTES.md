# Öğrenme Notları — OTA Temelleri

## OTA nedir?

OTA, `Over-the-Air Update` ifadesinin kısaltmasıdır. Firmware'in UART kablosuyla değil ağ üzerinden indirilip flash'a yazılmasıdır. OTA yalnız bir taşıma ve güncelleme yöntemidir; tek başına güvenlik özelliği değildir.

## Secure OTA nedir?

Secure OTA tek bir özellik değil, birlikte çalışan kontroller bütünüdür:

- Sunucu kimliğinin TLS ile doğrulanması
- Firmware bütünlüğünün kontrol edilmesi
- Firmware üreticisinin dijital imzayla doğrulanması
- Eski güvenlik sürümlerinin anti-rollback ile engellenmesi
- Başarısız image durumunda known-good slota geri dönülmesi
- Gerekliyse flash içeriğinin şifrelenmesi

## OTA slotu nedir?

Slot, flash içindeki bir application partition'dır. İki slotlu sistemde çalışan uygulama bir slotta dururken yeni image diğer slota yazılır.

```text
ota_0: çalışan uygulama
ota_1: yeni image buraya yazılır
```

Güncelleme tamamlandıktan sonra boot seçimi değiştirilir. Böylece indirme yarıda kesilirse çalışan uygulamanın üstüne yazılmamış olur.

## otadata nedir?

`otadata`, bootloader'ın hangi OTA slotunu açacağını belirleyen küçük metadata partition'ıdır. Firmware image'ın kendisini içermez; slot seçim durumunu taşır.

## Factory partition zorunlu mu?

Hayır. Bazı yerleşimlerde ilk/kurtarma uygulaması için `factory` bulunur. Bazılarında yalnız `ota_0` ve `ota_1` kullanılır. Bu laboratuvar iki büyük OTA slotuna alan bırakmak için factory partition kullanmaz.

## OTA ile Secure Boot arasındaki ilişki

OTA image'ı flash'a getirir. Secure Boot ise açılış sırasında image'ın yetkili anahtarla imzalanıp imzalanmadığını denetler.

```text
OTA: Image cihaza nasıl ulaştı?
Secure Boot: Ulaşan image çalıştırılmaya yetkili mi?
```

HTTPS doğru sunucudan indirmeyi korur; Secure Boot ise flash'a başka bir yoldan yazılmış image'a karşı da açılış kontrolü sağlar.

## Rollback ve anti-rollback aynı şey değildir

- **Rollback/recovery:** Yeni sürüm bozuksa bilinen iyi sürüme geri dönmek.
- **Anti-rollback:** Eski ve artık yasaklanmış güvenlik sürümüne dönmeyi engellemek.

İyi tasarlanmış bir cihaz, hatalı yeni image'dan kurtulabilmeli fakat bilinen açığı olan eski güvenlik sürümüne dönememelidir.
