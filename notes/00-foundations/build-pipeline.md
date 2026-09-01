# Kaynak Koddan ESP32-C3 Firmware'ine

## Temel akış

```text
C kaynak kodu
    ↓
CMake: derleme planını hazırlar
    ↓
Ninja: gerekli derleme adımlarını çalıştırır
    ↓
RISC-V derleyicisi: C kodunu makine koduna çevirir
    ↓
Linker: parçaları birleştirip ELF üretir
    ↓
ESP-IDF araçları: flashlanabilir BIN dosyalarını üretir
    ↓
esptool: BIN dosyalarını kartın flash belleğine yazar
```

## Araçların kısa görevleri

- `idf.py`: ESP-IDF iş akışını başlatan üst düzey komuttur.
- CMake: Hangi kaynakların ve ayarların kullanılacağını planlar.
- Ninja: Plandaki gerekli işleri doğru sırayla yürütür.
- Derleyici: C kaynak kodunu işlemcinin komutlarına dönüştürür.
- Linker: Derlenen parçaları ve kütüphaneleri adresleriyle birleştirir.
- esptool: Hazırlanan firmware'i seri/USB bağlantısı üzerinden flash belleğe yazar.

## Dosyalar

- `.c`: İnsan tarafından yazılan C kaynak kodu
- `.o`: Bir kaynak dosyasının derlenmiş ara çıktısı
- `.elf`: Kod, veri, sembol ve hata ayıklama bilgisi içeren birleşik program
- `.bin`: Flash belleğe yazılacak ham ikili görüntü
- `.map`: Program bölümlerinin bellekte nereye yerleştirildiğini gösteren rapor

## Kalıcılık

Makine koduna çevrilmek tek başına programı kalıcı yapmaz. Firmware güç kesildiğinde silinmeyen flash belleğe yazıldığı için kart yeniden açıldığında tekrar çalışır.
