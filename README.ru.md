<div align="center">

[![English](https://img.shields.io/badge/README-English-blue)](README.md)
[![Русский](https://img.shields.io/badge/README-Русский-red)](README.ru.md)
[![Oʻzbekcha](https://img.shields.io/badge/README-Oʻzbekcha-green)](README.uz.md)

</div>

# ProxmOps — Day-2 операции Proxmox VE

Продакшн-готовые скрипты и runbook'и для day-2 операций на автономных нодах Proxmox VE: провижининг VM через cloud-init, изменение размера дисков, управление золотыми шаблонами.

## Что внутри

### 🖥 Провижининг VM (cloud-init)
- Клонирование из золотого шаблона (template → full clone → cloud-init → verify)
- Сборка шаблона Ubuntu 24.04 cloud-image с QEMU guest-agent
- Система vendor-snippet'ов для установки пакетов при первой загрузке
- Настройка SSH: ключ + пароль с исправлением cloudimg-override

### 💾 Операции с дисками
- Онлайн-расширение диска VM (гипервизор + партиция + файловая система)
- Последовательность growpart / resize2fs для cloud-image layouts
- Варианты для LVM и ext4/xfs

### ✅ Философия «сначала проверь»
Каждая операция: **сделал → проверил → отчитался**. Скрипты опрашивают статус, сверяют MAC-адреса с ARP-записями, подтверждают изменения ФС до объявления успеха.

## Стек
- Proxmox VE 9.x (автономные ноды, без кластера)
- Ubuntu 24.04 LTS cloud images
- Bash + Python (только stdlib, без зависимостей)

## Типичные ловушки (из реальных инцидентов)

1. **LXC-шаблон ≠ диск VM** — импорт `.tar.zst` как диска VM создаёт 135MB мусор
2. **IP отвечает на ping ≠ свободный IP** — всегда сканируй перед назначением
3. **cloudimg SSH override** — Ubuntu cloud images содержат `PasswordAuthentication no`; `cipassword` это не переопределяет
4. **Пересоздание VM сбрасывает SSH** — каждый destroy+clone возвращает настройки по умолчанию

## Использование

```bash
./scripts/clone_vm.sh --template 9000 --name webserver --ip 10.0.0.50
./scripts/resize_disk.sh --vmid 102 --disk scsi0 --size 50G
./scripts/verify_vm.sh --vmid 102 --expected-ip 10.0.0.50
```

## 📬 Контакты

Вопросы? Пишите: **[allumaxmail@gmail.com](mailto:allumaxmail@gmail.com)**

---

<div align="center">

[![English](https://img.shields.io/badge/README-English-blue)](README.md)
[![Русский](https://img.shields.io/badge/README-Русский-red)](README.ru.md)
[![Oʻzbekcha](https://img.shields.io/badge/README-Oʻzbekcha-green)](README.uz.md)

</div>
