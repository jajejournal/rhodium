#!/usr/bin/env bash
set -euo pipefail

# --- Main Configuration ---
APP_NAME="rh-vpn"
APP_TITLE="Rhodium's VPN"

# --- Imports ---
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../common/bootstrap.sh"

VPN_CONFIG_DIR="/etc/wireguard"

# Get list of VPN interface names (strip .conf)
vpn_interfaces=()
if [[ -d "$VPN_CONFIG_DIR" ]]; then
  mapfile -t vpn_interfaces < <(find "$VPN_CONFIG_DIR" -maxdepth 1 -name '*.conf' -exec basename {} .conf \;)
fi

# Check active interfaces
active=""
for iface in "${vpn_interfaces[@]}"; do
  if ip link show "$iface" &>/dev/null; then
    active="$iface"
    break
  fi
done

if [[ -n "$active" ]]; then
  echo " $active"
else
  echo ""
fi

