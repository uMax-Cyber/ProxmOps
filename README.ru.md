<div align="center">

[![English](https://img.shields.io/badge/README-English-blue)](README.md)
[![Русский](https://img.shields.io/badge/README-Русский-red)](README.ru.md)
[![Oʻzbekcha](https://img.shields.io/badge/README-Oʻzbekcha-green)](README.uz.md)

</div>

# Инструментарий Day-2 операций Proxmox

![Демо](screenshots/demo.svg)
[![CI](https://github.com/uMax-Cyber/ProxmOps/actions/workflows/ci.yml/badge.svg)](https://github.com/uMax-Cyber/ProxmOps/actions/workflows/ci.yml)

Готовые к продакшену скрипты и runbook'и для day-2 операций на автономных нодах Proxmox VE: провижининг виртуальных машин через cloud-init, изменение размера дисков, управление золотыми шаблонами и workflows с обязательной верификацией.

## Что внутри

### 🖥 Провижининг VM (cloud-init)
- Workflow клонирования по «золотому пути» (шаблон → полное клонирование → cloud-init → проверка)
- Сборка шаблона Ubuntu 24.04 cloud-image с QEMU guest-agent
- Система vendor-snippet'ов для установки пакетов при первой загрузке
- Настройка авторизации по SSH-ключу и паролю с исправлением cloudimg-override

### 💾 Операции с дисками
- Онлайн-расширение диска VM (гипервизор + партиция в гостевой ОС + файловая система)
- Последовательность `growpart` / `resize2fs` для раскладок cloud-image
- Варианты для LVM и ext4/xfs

### ✅ Философия «сначала проверь»
Каждая операция строится по схеме: **сделал → проверил → отчитался**. Скрипты опрашивают статус, сверяют MAC-адреса с ARP-записями и подтверждают изменения файловой системы, прежде чем объявить успех.

## Стек
- Proxmox VE 9.x (автономные ноды, без кластера)
- Cloud-образы Ubuntu 24.04 LTS
- Bash + Python (только stdlib, без внешних зависимостей)

## Ключевые скрипты

| Скрипт | Назначение |
|--------|------------|
| `scripts/clone_vm.sh` | Полное клонирование из шаблона с cloud-init |
| `scripts/resize_disk.sh` | Двухэтапное онлайн-расширение диска (хост + гость) |
| `scripts/seed_template.sh` | Сборка золотого шаблона на новой ноде |
| `scripts/verify_vm.sh` | Чек-лист проверки после провижининга |

## Типичные ловушки (задокументированы по реальным инцидентам)

1. **LXC-шаблон ≠ диск VM** — импорт контейнерных шаблонов `.tar.zst` как дисков VM создаёт 135MB мусора
2. **IP отвечает на ping ≠ свободный IP** — всегда сканируйте подсеть перед назначением; в плотных подсетях есть «тихие» владельцы
3. **cloudimg SSH override** — Ubuntu cloud-образы поставляются с `PasswordAuthentication no` в `/etc/ssh/sshd_config.d/`; один только `cipassword` это не переопределяет
4. **Пересоздание VM сбрасывает SSH** — любой цикл destroy+clone возвращает настройки cloud-image по умолчанию; после каждого пересоздания заново применяйте SSH-фикс

## Использование

```bash
# Клонировать VM из золотого шаблона
./scripts/clone_vm.sh --template 9000 --name webserver --ip 10.0.0.50

# Онлайн-расширение диска (без простоя)
./scripts/resize_disk.sh --vmid 102 --disk scsi0 --size 50G

# Проверить провижининг
./scripts/verify_vm.sh --vmid 102 --expected-ip 10.0.0.50
```

## Лицензия
MIT

## 📬 Контакты

Вопросы? Пишите: **[allumaxmail@gmail.com](mailto:allumaxmail@gmail.com)**

---

<div align="center">

[![English](https://img.shields.io/badge/README-English-blue)](README.md)
[![Русский](https://img.shields.io/badge/README-Русский-red)](README.ru.md)
[![Oʻzbekcha](https://img.shields.io/badge/README-Oʻzbekcha-green)](README.uz.md)

</div>
