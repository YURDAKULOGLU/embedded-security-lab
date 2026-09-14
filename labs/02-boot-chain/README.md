# Lab 02 — Boot Zincirini Gözle

ROM bootloader, ikinci aşama bootloader, partition table ve uygulama arasındaki geçiş boot logları ve binary çıktıları üzerinden incelenecektir. Her aşama için “kim, kimi, hangi bilgiyle doğruluyor veya yüklüyor?” sorusu cevaplanacaktır.

## Deney

Karttaki normal Lab 01 firmware'i değiştirilmeden şu alanlar salt-okunur geri okunur:

- Bootloader: `0x00000`
- Partition table: `0x08000`
- Factory application: `0x10000`

Karttan okunan binary'lerin SHA-256 değerleri yerel build çıktılarıyla karşılaştırılır. Ardından yalnız bilgisayardaki partition table kopyasında tek bit değiştirilir ve tablonun MD5 bütünlük kontrolü tarafından reddedilmesi beklenir.

```powershell
.\Run-Lab.ps1 -Port COM8
```

## Güvenlik sınırı

Betik yalnız cihaz okuma komutları çalıştırır. Flash yazma, silme veya eFuse programlama yapmaz. Ham kanıtlar `evidence/private/` altında saklanır ve Git'e eklenmez.

Tamamlanan deneyin sonuçları ve hash kanıtları için [LAB_REPORT.md](LAB_REPORT.md) dosyasına bakın.
