{ ... }:
# ───────────────────────────────────────────────────────────────────────────
# Niri on Intel integrated graphics (i915 / xe). No proprietary drivers.
# ───────────────────────────────────────────────────────────────────────────
# The generic ./gpu.nix module already installs both Intel VA-API drivers and
# lets libva pick the right one (i965 vs iHD), so this works on old and new
# Intel iGPUs alike.
{
  imports = [
    ./base.nix
    ./gpu.nix
  ];
}
