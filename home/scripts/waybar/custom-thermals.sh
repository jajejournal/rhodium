#!/usr/bin/env bash

set -euo pipefail

# --- Raw Sensor Grabs ---
sensors_json() { sensors -j 2>/dev/null || echo '{}'; }

get_cpu_temp() {
    sensors_json | jq -r '
        first(.[] | select(has("Tctl")) | .Tctl.temp1_input) //
        first(.[] | select(has("Package id 0")) | .["Package id 0"].temp1_input) //
        first(.[] | select(has("Core 0")) | .["Core 0"].temp2_input) //
        empty'
}
get_amd_gpu_temp() { sensors_json | jq -r 'first(.[] | select(has("edge")) | .edge.temp1_input) // empty'; }
get_amd_gpu_power() { sensors_json | jq -r 'first(.[] | select(has("PPT")) | .PPT.power1_input) // empty'; }
get_nvidia_gpu_temp() { sensors_json | jq -r 'first(.[] | select(has("Composite")) | .Composite.temp1_input) // empty'; }
get_nvme_temp() { sensors_json | jq -r 'first(.[] | select((.Adapter // "") == "PCI adapter" and .temp1.temp1_input and (.temp1.temp1_input < 100)) | .temp1.temp1_input) // empty'; }
get_ambient_temp() { sensors_json | jq -r 'first(.[] | select(.Adapter == "ACPI interface" and .temp1.temp1_input) | .temp1.temp1_input) // empty'; }
get_bat_v() { sensors_json | jq -r 'first(.[] | select(.in0.in0_input) | .in0.in0_input) // empty'; }
get_bat_i() {
    # Prefer the current sensor; otherwise derive current from power/voltage.
    sensors_json | jq -r '
        first(.[] | select(.curr1.curr1_input) | .curr1.curr1_input) //
        first(.[] | select(.power1.power1_input and .in0.in0_input) | (.power1.power1_input / .in0.in0_input)) //
        empty'
}
get_fan_rpm() { sensors_json | jq -r 'first(.[] | select(has("fan1")) | .fan1.fan1_input) // empty'; }

# --- Tiny Format Helpers ---
is_number() {
    [[ -n "${1:-}" && "$1" != "null" && "$1" =~ ^-?[0-9]+([.][0-9]+)?$ ]]
}

fmt_temp() {
    if is_number "${1:-}"; then
        printf '%.0f°C' "$1"
    else
        printf 'n/a'
    fi
}

fmt_unit() {
    local unit="$1" precision="$2" value="${3:-}"
    if is_number "$value"; then
        printf "%.${precision}f%s" "$value" "$unit"
    else
        printf 'n/a'
    fi
}

metric_json() {
    jq -nc --arg t "$1" '{text:$t, class:"bar_item"}'
}

# --- Output Selectors ---
case "${1:-}" in
cpu)
    metric_json "$(fmt_temp "$(get_cpu_temp)")"
    ;;
amd)
    metric_json "$(fmt_temp "$(get_amd_gpu_temp)")"
    ;;
nvidia)
    metric_json "$(fmt_temp "$(get_nvidia_gpu_temp)")"
    ;;
gpupower)
    metric_json "$(fmt_unit W 0 "$(get_amd_gpu_power)")"
    ;;
nvme)
    metric_json "$(fmt_temp "$(get_nvme_temp)")"
    ;;
amb)
    metric_json "$(fmt_temp "$(get_ambient_temp)")"
    ;;
batv)
    metric_json "$(fmt_unit V 2 "$(get_bat_v)")"
    ;;
bati)
    metric_json "$(fmt_unit A 2 "$(get_bat_i)")"
    ;;
fan)
    metric_json "$(fmt_unit RPM 0 "$(get_fan_rpm)")"
    ;;
full)
    jq -nc \
        --arg cpu "$(fmt_temp "$(get_cpu_temp)")" \
        --arg agpu "$(fmt_temp "$(get_amd_gpu_temp)")" \
        --arg ngpu "$(fmt_temp "$(get_nvidia_gpu_temp)")" \
        --arg pwr "$(fmt_unit W 0 "$(get_amd_gpu_power)")" \
        --arg nvme "$(fmt_temp "$(get_nvme_temp)")" \
        --arg amb "$(fmt_temp "$(get_ambient_temp)")" \
        --arg bv "$(fmt_unit V 2 "$(get_bat_v)")" \
        --arg bi "$(fmt_unit A 2 "$(get_bat_i)")" \
        --arg fan "$(fmt_unit RPM 0 "$(get_fan_rpm)")" \
        '{text:($cpu+"  AMD "+$agpu+"  NV "+$ngpu+"  GPU "+$pwr+"  NVMe "+$nvme+"  Amb "+$amb+"  Bat "+$bv+" "+$bi+"  Fan "+$fan)}'
    ;;
*) # summary (CPU only) with percentage for icon colouring
    cpu="$(get_cpu_temp)"
    if is_number "$cpu"; then
        jq -nc --arg cpu "$(fmt_temp "$cpu")" --argjson pct "$(printf '%.0f' "$cpu")" \
            '{text:$cpu, percentage:$pct, class:"bar_item"}'
    else
        jq -nc --arg cpu "n/a" '{text:$cpu, percentage:0, class:"bar_item"}'
    fi
    ;;
esac
