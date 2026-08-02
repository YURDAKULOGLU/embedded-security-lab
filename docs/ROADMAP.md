# Öğrenme Yol Haritası

## Aşama 1 — Geliştirme temeli

- ESP-IDF araç zinciri
- C derleme süreci
- Binary, ELF, map ve partition çıktıları
- Seri port ve boot logları
- Git ile deney kontrol noktaları

## Aşama 2 — Mikrodenetleyici ve çevre birimleri

- CPU, bellek haritası ve register mantığı
- GPIO ve polling
- Interrupt, ISR ve NVIC karşılaştırması
- Timer ve PWM
- ADC/DAC
- Watchdog
- Clock ve PLL
- Polling, interrupt ve DMA ölçüm deneyi

## Aşama 3 — Haberleşme

- UART
- SPI
- I2C
- CAN ve CAN-FD
- RS-485
- Modbus RTU ve TCP
- Logic analyzer ile çerçeve gözlemi
- Hata enjeksiyonu ve timeout davranışı

## Aşama 4 — Bare-metal ve FreeRTOS

- Task ve scheduler
- Context switch
- Queue, mutex ve semaphore
- Race condition
- Deadlock
- Priority inversion ve priority inheritance
- Zamanlama ve stack ölçümleri

## Aşama 5 — Cihaz güvenliği

- Hash ve dijital imza
- Secure Boot ve chain of trust
- Root of trust
- eFuse
- Flash encryption
- Güvenli anahtar saklama
- HSM ve secure element
- Secure OTA ve rollback
- AES-GCM ve SHA-256

## Aşama 6 — Ağ kimliği ve kriptografi

- TLS ve mTLS
- PKI ve X.509
- Sertifika zinciri
- Cihaz provisioning
- Anahtar rotasyonu ve iptal
- Klasik ve post-kuantum algoritmaların rolü

## Aşama 7 — Gömülü Linux

- Cross-compilation
- U-Boot
- Device tree
- Kernel ve userspace
- Yocto ve BitBake
- dm-verity
- Güvenli gateway mimarisi

## Bitirme projesi

ESP32 tabanlı bir cihazın imzalı firmware, güvenli boot, mTLS cihaz kimliği ve imzalı OTA güncelleme zincirini kur. Tehdit modeli, mimari, deney kanıtları ve saldırı testlerini raporla.
