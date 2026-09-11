<div align="center">

[![English](https://img.shields.io/badge/README-English-blue)](README.md)
[![Русский](https://img.shields.io/badge/README-Русский-red)](README.ru.md)
[![Oʻzbekcha](https://img.shields.io/badge/README-Oʻzbekcha-green)](README.uz.md)

</div>

# ProxmOps — Proxmox VE Day-2 Operatsiyalari

# ProxmOps — Proxmox VE kundalik operatsiyalar

Production muhitida sinovdan oʻtgan skriptlar va qoʻllanmalar: cloud-init yordamida virtual mashina yaratish, disk hajmini kengaytirish va oltin shablonlar bilan ishlash.

## Mundarija

### 🖥 Virtual mashina yaratish (cloud-init)
- Oltin shablondan toʻliq klonlash → cloud-init → tekshirish
- Ubuntu 24.04 cloud-image shabloni, QEMU guest-agent bilan
- Birinchi ishga tushirishda paketlarni oʻrnatish uchun vendor-snippet
- SSH: kalit + parol, cloudimg-override xatosini tuzatish bilan

### 💾 Disk operatsiyalari
- Virtual mashina diskini oʻchirmasdan kengaytirish
- growpart va resize2fs — cloud-image uchun
- LVM, ext4 va xfs fayl tizimlari qoʻllab-quvvatlanadi

### ✅ Asosiy tamoyil: «Qil → Tekshir → Hisobot»
Har bir amal bajarilgach, natija mustaqil ravishda tekshiriladi. Skriptlar holatni kuzatadi, MAC-manzillarni ARP yozuvlari bilan solishtiradi va fayl tizimidagi oʻzgarishlarni tasdiqlaydi.

## Texnologiyalar
- Proxmox VE 9.x (mustaqil nodelar)
- Ubuntu 24.04 LTS cloud images
- Bash va Python (faqat standart kutubxona)

## Amaliyotda uchraydigan xatolar

1. **LXC shabloni — bu VM diski emas** — `.tar.zst` faylini VM diski sifatida import qilish 135 MB li ishlamaydigan disk yaratadi
2. **Ping javob beradi — bu boʻsh IP degani emas** — tayinlashdan oldin albatta skanerlang
3. **cloudimg SSH cheklovi** — Ubuntu cloud-images `PasswordAuthentication no` bilan keladi; `cipassword` buni bekor qilmaydi
4. **VM qayta yaratilganda SSH sozlamalari tiklanadi** — har bir destroy+clone standart holatga qaytaradi

## Ishlatish

```bash
./scripts/clone_vm.sh --template 9000 --name webserver --ip 10.0.0.50
./scripts/resize_disk.sh --vmid 102 --disk scsi0 --size 50G
./scripts/verify_vm.sh --vmid 102 --expected-ip 10.0.0.50
```


## 📬 Aloqa

Savollaringiz bormi? Yozing: **[allumaxmail@gmail.com](mailto:allumaxmail@gmail.com)**

---

<div align="center">

[![English](https://img.shields.io/badge/README-English-blue)](README.md)
[![Русский](https://img.shields.io/badge/README-Русский-red)](README.ru.md)
[![Oʻzbekcha](https://img.shields.io/badge/README-Oʻzbekcha-green)](README.uz.md)

</div>

