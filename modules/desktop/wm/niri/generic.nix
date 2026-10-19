{ ... }:
# ───────────────────────────────────────────────────────────────────────────
# Niri on "any" GPU (auto-detect friendly).
# ───────────────────────────────────────────────────────────────────────────
# Same as ./intel.nix for now: the shared ./gpu.nix installs the free Mesa +
# Intel/AMD VA-API drivers and lets the system pick what the hardware supports.
# Use this for a brand-new laptop/desktop and switch to ./nvidia.nix only if the
# machine has an NVIDIA GPU (proprietary driver, opt-in).
{
  imports = [
    ./base.nix
    ./gpu.nix
  ];
}
