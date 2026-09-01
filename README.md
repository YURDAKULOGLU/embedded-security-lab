# Embedded Security Lab — ESP32 Hardware + Secure Lifecycle Proof-of-Work

Bu depo gömülü sistem güvenliğini **tahmin → deney → bozma → teşhis → açıklama → evidence** döngüsüyle öğrenmek için oluşturulmuş kişisel laboratuvardır. İlk ESP32 laboratuvarları ile Secure Boot pratiğini; yeni host-side lifecycle modeli ile trust anchor, revocation, anti-rollback, A/B recovery ve traceability konularını tek çalışma alanında birleştirir.

> Bu kişisel bir eğitim/proof-of-work deposudur; Cyber Quanta'nın, NXP'nin, Silicon Labs'ın veya Espressif'in resmî yazılımı/dokümantasyonu değildir.

## Kanıt sınırı

Bu repoda üç farklı iddia seviyesi birbirine karıştırılmaz:

- `HOST_VERIFIED` — çalıştırılabilir host modeli/testi geçti.
- `SOURCE_REVIEWED` — mimari veya kaynak incelendi; gerçek kart kanıtı değildir.
- `HARDWARE_PENDING` — ilgili fiziksel hedef henüz test edilmedi.
- `HARDWARE_VERIFIED` — gerçek cihazdan tekrarlanabilir evidence toplandı.

Gerçek donanım ana yolu **ESP32**'dir. i.MX93/AHAB ve EFR32 çalışmaları mimari/source-review track'idir; ilgili kart olmadan hardware proof iddiası yapılmaz.

## Öğrenme yöntemi

```text
Problem
  ↓
Tahmin
  ↓
Deney
  ↓
Gözlem
  ↓
Kasıtlı negatif test
  ↓
Teşhis
  ↓
Kendi cümlenle açıklama
  ↓
Evidence artifact
```

Bir komutun çalışması tek başına öğrenme kanıtı değildir. Şunları açıklayabilmek gerekir: mekanizma hangi problemi çözüyor, neyi çözmüyor, güven nerede başlıyor, hangi negatif test enforcement'ı kanıtlar ve başka bir mühendise hangi artifact gösterilir?

## Şu anda kapsanan alanlar

- ESP-IDF ortamı, çip keşfi ve ESP32 boot chain
- Hash, integrity, public/private key ve firmware signing
- Secure Boot emülasyonu ve gerçek donanım güvenlik kapısı
- Root of Trust, Trust Anchor, Chain of Trust
- Çoklu trusted-key modeli, key rotation ve revocation
- AHAB-style authenticated-container karar modeli (vendor binary parser değildir)
- Lifecycle / open-vs-closed enforcement mantığı
- Signed A/B update, recovery rollback ve anti-rollback
- Manifest, metadata, artifact ve evidence
- Requirement → mechanism → test → acceptance criterion → evidence traceability
- ESP32 gerçek hardware proof-of-work akışı
- i.MX93/AHAB ve EFR32 architecture study track'leri

## Hızlı başlangıç

### ESP32 tarafı

Önce [`ESP32_FIRST.md`](ESP32_FIRST.md) dosyasını oku. Mevcut eski lab akışı:

| No | Lab | Hedef |
|---:|---|---|
| 00 | `labs/00-environment` | Araç zinciri / reproducibility |
| 01 | `labs/01-chip-discovery` | Çip, revision, ROM/serial evidence |
| 02 | `labs/02-boot-chain` | ROM → bootloader → partition → app |
| 03 | `labs/03-firmware-signing` | Hash, key pair, signature |
| 04 | `labs/04-secure-boot-emulation` | Signed/tampered image davranışı |
| 05 | `labs/05-secure-boot-hardware` | Gerçek Secure Boot/eFuse gate |

### Yeni lifecycle / proof track'i

| No | Lab | Hedef |
|---:|---|---|
| 06 | [`trust-anchor-revocation`](labs/06-trust-anchor-revocation/README.md) | Trust anchor, rotation, revocation |
| 07 | [`authenticated-container`](labs/07-authenticated-container/README.md) | Metadata + payload + policy binding |
| 08 | [`lifecycle-close-gate`](labs/08-lifecycle-close-gate/README.md) | Authentication vs enforcement, irreversible gate |
| 09 | [`ab-update-antirollback`](labs/09-ab-update-antirollback/README.md) | Recovery rollback vs anti-rollback |
| 10 | [`traceability-evidence`](labs/10-traceability-evidence/README.md) | Requirement'tan evidence'a zincir |
| 11 | [`esp32-hardware-proof`](labs/11-esp32-hardware-proof/README.md) | Gerçek cihaz proof-of-work |

Host-side modeli çalıştır:

```bash
python -m security_lab.host_lab
python -m unittest tests.test_host_lab -v
```

Model şu negatif durumları otomatik sınar: payload tamper, revoked signer, eski security version ve başarısız A/B update sonrası known-good slotun korunması.

## ESP-IDF ortamı

Mevcut çalışma ortamı ESP-IDF tabanlıdır. Windows'ta proje kökünde:

```powershell
. .\scripts\Enter-EspIdf.ps1
.\scripts\Check-Environment.ps1
```

Kart üzerinde işlem yapmadan önce exact SoC target, chip revision, ESP-IDF version, partition table ve eFuse state kaydedilir.

## Güvenlik kuralları

Secure Boot / Flash Encryption / eFuse deneyleri kalıcı değişiklik içerebilir.

- `espefuse burn_*` benzeri komutlar otomatik çalıştırılmaz.
- Exact çip/revision doğrulanmadan eFuse yazılmaz.
- Before-state eFuse özeti kaydedilir.
- Private signing key Git'e girmez.
- Known-good signed recovery image olmadan provisioning yapılmaz.
- Tamper/wrong-key/recovery negatif testleri önce tamamlanır.
- Güç/USB kararsızsa irreversible işlem yapılmaz.

Ayrıntı: [`docs/SAFETY.md`](docs/SAFETY.md) ve [`docs/PUBLIC_SOURCE_BOUNDARY.md`](docs/PUBLIC_SOURCE_BOUNDARY.md).

## Public-source boundary

Public repo bilinçli olarak şunları **yeniden dağıtmaz**: staj/internal PDF'leri, notebook fotoğrafları, proprietary kaynak paketleri, private signing key'ler ve lisansı public dağıtıma izin vermeyen materyaller. Burada yayınlanan kısım öğrenme modeli, testler, açıklamalar ve public-safe proof-of-work altyapısıdır.

## Dizin yapısı

```text
.
├── labs/             ESP32 + lifecycle laboratuvarları
├── security_lab/     vendor-neutral çalıştırılabilir host modeli
├── tests/            host model negatif/recovery testleri
├── docs/             safety, mastery, roadmap ve source boundary
├── evidence/         gerçek/host proof artifact alanı
├── scripts/          ESP-IDF ve yardımcı araçlar
├── release/          public-safe capstone/release metadata
└── .github/          CI ve repo workflow'ları
```

## Lisans

Bu public repoya eklenen özgün eğitim framework'ü ve host-side model kodu MIT lisansı altındadır. Üçüncü taraf marka, spesifikasyon ve materyaller kendi sahiplerine aittir; proprietary vendor/company source bu repoda yeniden dağıtılmaz.
