#!/usr/bin/env bash
# Clone VM from golden template with cloud-init provisioning.
# Usage: clone_vm.sh --template 9000 --name web01 --ip 10.0.0.50 [--node pve2]
set -euo pipefail

TEMPLATE=9000; NAME=""; IP=""; NODE="pve2"

while [[ $# -gt 0 ]]; do
  case $1 in
    --template) TEMPLATE="$2"; shift 2 ;;
    --name) NAME="$2"; shift 2 ;;
    --ip) IP="$2"; shift 2 ;;
    --node) NODE="$2"; shift 2 ;;
    *) echo "Unknown: $1"; exit 1 ;;
  esac
done

[[ -z "$NAME" || -z "$IP" ]] && { echo "Usage: $0 --name X --ip X.X.X.X"; exit 1; }

# 1. Pick free VMID
NEWID=$(ssh "root@${NODE}" "pvesh get /cluster/nextid" | tr -d '"')

# 2. Scan for free IP (ping sweep — silence = free)
echo "Scanning for free IPs..."
OCTET=$(echo "$IP" | cut -d. -f4)
BASE=$(echo "$IP" | cut -d. -f1-3)
for i in $(seq 130 149); do
  TEST_IP="${BASE}.${i}"
  if ! ping -c1 -W1 "$TEST_IP" &>/dev/null; then
    IP="$TEST_IP"; echo "Using free IP: $IP"; break
  fi
done

# 3. Generate credentials
PW=$(openssl rand -base64 12)

# 4. Clone
ssh "root@${NODE}" "qm clone $TEMPLATE $NEWID --full 1 --name $NAME"

# 5. Cloud-init
ssh "root@${NODE}" "qm set $NEWID --ciuser ubuntu --cipassword '$PW' \
  --ipconfig0 ip=${IP}/24,gw=${BASE}.1 \
  --sshkeys /root/.ssh/id_rsa.pub"

# 6. Start
ssh "root@${NODE}" "qm start $NEWID"

# 7. Wait for guest agent (installs on first boot, 60-120s)
echo "Waiting for guest agent..."
for i in $(seq 1 15); do
  sleep 10
  if ssh "root@${NODE}" "qm agent $NEWID ping" &>/dev/null; then
    echo "Agent up after ${i}0s"; break
  fi
done

# 8. Get IP from agent (ground truth)
AGENT_IP=$(ssh "root@${NODE}" "qm agent $NEWID network-get-interfaces" | jq -r '.[] | select(.name=="eth0") | .["ip-addresses"][0]["ip-address"]')

# 9. Test SSH (key + password)
ssh -o StrictHostKeyChecking=accept-new "ubuntu@${AGENT_IP}" 'echo KEY_OK' || echo "KEY FAIL"

echo "=== VM $NEWID ($NAME) ==="
echo "IP: $AGENT_IP"
echo "Login: ubuntu"
echo "Password: $PW"
