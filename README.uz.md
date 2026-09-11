<div align="center">

**🇬🇧 [English](README.md) · 🇷🇺 [Русский](README.ru.md) · 🇺🇿 [Oʻzbekcha](README.uz.md)**

</div>

# ProxmOps — Proxmox VE Day-2 Operatsiyalari

Production-tayyor skriptlar va runbooklar: cloud-init orqali VM yaratish, disk kengaytirish, oltin shablonlar boshqaruvi.

## Nima bor

### 🖥 VM Yaratish (cloud-init)
- Oltin shablondan klonlash (template → full clone → cloud-init → verify)
- Ubuntu 24.04 cloud-image shabloni QEMU guest-agent bilan
- Birinchi yuklashda paket o'rnatish uchun vendor-snippet tizimi
- SSH sozlash: kalit + parol, cloudimg-override tuzatish bilan

### 💾 Disk Operatsiyalari
- Onlayn disk kengaytirish (hypervisor + partition + filesystem)
- growpart / resize2fs ketma-ketligi cloud-image uchun
- LVM va ext4/xfs variantlari

### ✅ «Avval tekshir» falsafasi
Har bir operatsiya: **qil → tekshir → hisobot qil**. Skriptlar holatni so'raydi, MAC-manzillarni ARP bilan solishtiradi, FS o'zgarishini tasdiqlaydi.

## Stack
- Proxmox VE 9.x (mustaqil nodelar, klastersiz)
- Ubuntu 24.04 LTS cloud images
- Bash + Python (faqat stdlib, bog'liqliksiz)

## Oddiy xatolar (real hodisalardan)

1. **LXC shablon ≠ VM diski** — `.tar.zst` ni VM diski sifatida import qilish 135MB axlat yaratadi
2. **Ping javob beradi ≠ bo'sh IP** — tayinlashdan oldin skanerlang
3. **cloudimg SSH override** — Ubuntu cloud images `PasswordAuthentication no` bilan keladi; `cipassword` buni bekor qilmaydi
4. **VM qayta yaratish SSH ni tiklaydi** — har bir destroy+clone standart sozlamalarni qaytaradi

## Foydalanish

```bash
./scripts/clone_vm.sh --template 9000 --name webserver --ip 10.0.0.50
./scripts/resize_disk.sh --vmid 102 --disk scsi0 --size 50G
./scripts/verify_vm.sh --vmid 102 --expected-ip 10.0.0.50
```

## 📬 Aloqa

Savollar bormi? Yozing: **[allumaxmail@gmail.com](mailto:allumaxmail@gmail.com)**

---

<div align="center">

**🇬🇧 [English](README.md) · 🇷🇺 [Русский](README.ru.md) · 🇺🇿 [Oʻzbekcha](README.uz.md)**

</div>
