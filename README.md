<div align="center">

[![English](https://img.shields.io/badge/README-English-blue)](README.md)
[![Русский](https://img.shields.io/badge/README-Русский-red)](README.ru.md)
[![Oʻzbekcha](https://img.shields.io/badge/README-Oʻzbekcha-green)](README.uz.md)

</div>

# Proxmox Day-2 Ops Toolkit

![Demo](screenshots/demo.svg)
[![CI](https://github.com/uMax-Cyber/ProxmOps/actions/workflows/ci.yml/badge.svg)](https://github.com/uMax-Cyber/ProxmOps/actions/workflows/ci.yml)

Production-ready scripts and runbooks for day-2 operations on standalone Proxmox VE nodes: VM provisioning via cloud-init, disk resizing, golden template management, and verification-first workflows.

## What's Inside

### 🖥 VM Provisioning (cloud-init)
- Golden-path VM clone workflow (template → full clone → cloud-init → verify)
- Ubuntu 24.04 cloud-image template builder with QEMU guest-agent
- Vendor snippet system for first-boot package installation
- SSH key + password auth configuration with cloudimg-override fix

### 💾 Disk Operations
- Online VM disk resize (hypervisor + guest partition + filesystem)
- `growpart` / `resize2fs` sequencing for cloud-image layouts
- LVM and ext4/xfs variants

### ✅ Verification-First Philosophy
Every operation follows: **do → verify → report**. Scripts poll status, match MAC addresses to ARP entries, and confirm filesystem changes before declaring success.

## Stack
- Proxmox VE 9.x (standalone nodes, no cluster)
- Ubuntu 24.04 LTS cloud images
- Bash + Python (stdlib only, no dependencies)

## Key Scripts

| Script | Purpose |
|--------|---------|
| `scripts/clone_vm.sh` | Full-clone from template with cloud-init |
| `scripts/resize_disk.sh` | Two-stage online disk resize (host + guest) |
| `scripts/seed_template.sh` | Build golden template on a new node |
| `scripts/verify_vm.sh` | Post-provisioning verification checklist |

## Common Traps (documented from real incidents)

1. **LXC template ≠ VM disk** — importing `.tar.zst` container templates as VM disks creates 135MB junk
2. **IP that pings ≠ free IP** — always scan before assigning; dense subnets have silent owners
3. **cloudimg SSH override** — Ubuntu cloud images ship `PasswordAuthentication no` in `/etc/ssh/sshd_config.d/`; cipassword alone doesn't override it
4. **VM recreate resets SSH** — any destroy+clone cycle resets cloud-image defaults; re-apply SSH fix after every recreate

## Usage

```bash
# Clone a VM from golden template
./scripts/clone_vm.sh --template 9000 --name webserver --ip 10.0.0.50

# Resize disk online (no downtime)
./scripts/resize_disk.sh --vmid 102 --disk scsi0 --size 50G

# Verify provisioning
./scripts/verify_vm.sh --vmid 102 --expected-ip 10.0.0.50
```

## License
MIT

## 📬 Contact

Questions? Reach out: **[allumaxmail@gmail.com](mailto:allumaxmail@gmail.com)**

---

<div align="center">

[![English](https://img.shields.io/badge/README-English-blue)](README.md)
[![Русский](https://img.shields.io/badge/README-Русский-red)](README.ru.md)
[![Oʻzbekcha](https://img.shields.io/badge/README-Oʻzbekcha-green)](README.uz.md)

</div>
