# Proxmox Provisioning Traps (Real Incidents)

## Trap 1: LXC Template ≠ VM Disk
Importing `/var/lib/vz/template/cache/ubuntu-*-standard_*.tar.zst` via `qm importdisk` creates a ~135MB non-bootable disk. These are **container templates** for `pct create`, not bootable VM images. VMs need cloud images (`.img`/`.qcow2`) from cloud-images.ubuntu.com.

**Fix**: Always clone from a golden template built from a real cloud image.

## Trap 2: An IP That Pings ≠ Free IP
Dense subnets have silent owners (switches, APs, phones). A ping reply means somebody owns it — assigning it creates the worst failure mode: ping looks fine but you're talking to the wrong machine.

**Fix**: Ping sweep before assigning; verify guest MAC matches ARP entry after boot.

## Trap 3: cipassword Does Not Enable Password SSH
Ubuntu cloud images ship `/etc/ssh/sshd_config.d/60-cloudimg-settings.conf` with `PasswordAuthentication no`. Include-order means this file WINS over main sshd_config. `--cipassword` sets the password but SSH still refuses it.

**Fix**: Add `ssh_pwauth: true` to cloud-init vendor snippet, or manually rewrite the override file.

## Trap 4: VM Recreate Resets SSH Defaults
Any destroy + clone cycle resets cloud-image SSH to defaults (password auth off, new host key).

**Fix**: Always re-verify SSH after VM recreate; add `ssh-keygen -R <ip>` to known_hosts cleanup.

## Trap 5: Guest Agent Needs Time
First boot installs qemu-guest-agent via vendor snippet — takes 60-120 seconds. `qm agent ping` will fail during this window.

**Fix**: Poll with timeout, don't give up after one attempt.
