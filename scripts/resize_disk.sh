#!/usr/bin/env bash
# Online VM disk resize: hypervisor + guest partition + filesystem.
# Usage: resize_disk.sh --vmid 102 --disk scsi0 --size 50G [--node pve2]
set -euo pipefail

VMID=""; DISK="scsi0"; SIZE=""; NODE="pve2"; GUEST_USER="ubuntu"

while [[ $# -gt 0 ]]; do
  case $1 in
    --vmid) VMID="$2"; shift 2 ;;
    --disk) DISK="$2"; shift 2 ;;
    --size) SIZE="$2"; shift 2 ;;
    --node) NODE="$2"; shift 2 ;;
    *) echo "Unknown: $1"; exit 1 ;;
  esac
done

[[ -z "$VMID" || -z "$SIZE" ]] && { echo "Usage: $0 --vmid N --size NG"; exit 1; }

echo "=== STAGE 1: Resize on hypervisor ==="
ssh "root@${NODE}" "qm resize $VMID $DISK $SIZE"
ssh "root@${NODE}" "qm config $VMID | grep $DISK"

echo "=== STAGE 2: Grow partition + filesystem inside guest ==="
GUEST_IP=$(ssh "root@${NODE}" "qm guest cmd $VMID network-get-interfaces" | jq -r '.[] | select(.name=="eth0") | .["ip-addresses"][0]["ip-address"]')

ssh "root@${NODE}" "ssh $GUEST_USER@${GUEST_IP} '
  sudo growpart /dev/sda 1
  sudo resize2fs /dev/sda1
  df -h /
'"

echo "=== VERIFY ==="
ssh "root@${NODE}" "ssh $GUEST_USER@${GUEST_IP} 'df -h /'"
