<div align="center">

[![English](https://img.shields.io/badge/README-English-blue)](README.md)
[![Русский](https://img.shields.io/badge/README-Русский-red)](README.ru.md)
[![Oʻzbekcha](https://img.shields.io/badge/README-Oʻzbekcha-green)](README.uz.md)

</div>

# Proxmox day-2 operatsiyalar vositasi

![Demo](screenshots/demo.svg)
[![CI](https://github.com/uMax-Cyber/ProxmOps/actions/workflows/ci.yml/badge.svg)](https://github.com/uMax-Cyber/ProxmOps/actions/workflows/ci.yml)

Production muhitga tayyor skriptlar va qoʻllanmalar — mustaqil (standalone) Proxmox VE serverlarining kundalik ekspluatatsiyasi (day-2) uchun: cloud-init orqali VM yaratish, diskni kengaytirish, oltin shablonlar bilan ishlash va har bir amal oxirida tekshiruv oʻtkaziladigan ish oqimlari.

## Ichida nima bor

### 🖥 VM yaratish (cloud-init)
- Shablondan VM yaratishning toʻgʻri yoʻli (template → full clone → cloud-init → tekshirish)
- QEMU guest-agent oʻrnatilgan Ubuntu 24.04 cloud-image shablonini yaratish
- Birinchi ishga tushirishda kerakli paketlarni oʻrnatadigan vendor-snippet tizimi
- SSH kalit va parol bilan kirishni sozlash, cloudimg-override muammosini hal qilish bilan

### 💾 Disk operatsiyalari
- VM ishlab turgan holida diskni kengaytirish (gipervizor, VM ichidagi partitsiya va fayl tizimi)
- cloud-image disk tuzilishi uchun `growpart` / `resize2fs` ketma-ketligi
- LVM va ext4/xfs variantlari

### ✅ «Avval tekshir» tamoyili
Har bir amal shu tartibda bajariladi: **qil → tekshir → hisobot ber**. Skriptlar holatni soʻrab turadi, MAC-manzillarni ARP yozuvlari bilan solishtiradi va fayl tizimidagi oʻzgarishni oʻzi koʻrib tasdiqlaydi — shundan keyingina ish muvaffaqiyatli deb hisoblanadi.

## Texnologiyalar
- Proxmox VE 9.x (mustaqil serverlar, klaster emas)
- Ubuntu 24.04 LTS cloud-image lar
- Bash va Python (faqat standart kutubxona, tashqi bogʻliqlik yoʻq)

## Asosiy skriptlar

| Skript | Vazifasi |
|--------|----------|
| `scripts/clone_vm.sh` | Shablondan cloud-init bilan toʻliq klon yaratish |
| `scripts/resize_disk.sh` | Diskni ikki bosqichda, toʻxtatmasdan kengaytirish (host va guest tomonda) |
| `scripts/seed_template.sh` | Yangi serverda oltin shablon tayyorlash |
| `scripts/verify_vm.sh` | VM yaratilgach tekshiruvlar roʻyxatini oʻtkazish |

## Amaliyotdagi tipik xatolar (real voqealardan olingan)

1. **LXC shabloni — bu VM diski emas** — `.tar.zst` konteyner shablonini VM diski qilib import qilsangiz, 135MB lik ishlamaydigan «disk» paydo boʻladi
2. **Ping ga javob beradi — bu IP boʻsh degani emas** — IP tayinlashdan oldin subnetni albatta skanerlang; zich subnetlarda ayrim IP lar band boʻlsa-da, koʻzga tashlanmaydi
3. **cloudimg SSH cheklovi** — Ubuntu cloud-image lari `/etc/ssh/sshd_config.d/` ichida `PasswordAuthentication no` bilan keladi; `cipassword` yozishning oʻzi buni bekor qilmaydi
4. **VM qayta yaratilganda SSH sozlamalari tiklanadi** — destroy+clone tsikli cloud-image standart sozlamalarini qaytarib yuboradi; har safar qayta yaratgach SSH tuzatishini yana bir marta qoʻllang

## Ishlatish

```bash
# Oltin shablondan VM klonlash
./scripts/clone_vm.sh --template 9000 --name webserver --ip 10.0.0.50

# Diskni toʻxtatmasdan kengaytirish
./scripts/resize_disk.sh --vmid 102 --disk scsi0 --size 50G

# Yaratilgan VM ni tekshirish
./scripts/verify_vm.sh --vmid 102 --expected-ip 10.0.0.50
```

## Litsenziya
MIT

## 📬 Aloqa

Savollaringiz bormi? Yozing: **[allumaxmail@gmail.com](mailto:allumaxmail@gmail.com)**

---

<div align="center">

[![English](https://img.shields.io/badge/README-English-blue)](README.md)
[![Русский](https://img.shields.io/badge/README-Русский-red)](README.ru.md)
[![Oʻzbekcha](https://img.shields.io/badge/README-Oʻzbekcha-green)](README.uz.md)

</div>
