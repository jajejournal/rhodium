{
  pkgs,
  lib,
  ...
}:
# ───────────────────────────────────────────────────────────────────────────
# Generic GPU / firmware support (works on most PCs, old and modern)
# ───────────────────────────────────────────────────────────────────────────
# This module is shared by every host so the rice boots and renders on any
# machine without editing anything:
#
#   - Free, in-kernel drivers (Intel i915/xe, AMD amdgpu, nouveau) are enabled
#     by Mesa via `hardware.graphics.enable`.
#   - VA-API hardware video decode: we install BOTH Intel drivers (i965 for
#     Gen4–9 / Sandy→Broadwell, iHD for Gen8+) and let libva autodetect which
#     one to use. We deliberately do NOT set LIBVA_DRIVER_NAME, because forcing
#     iHD breaks old Intel GPUs (e.g. Sandy Bridge ThinkPads) and forcing i965
#     breaks new ones.
#   - Redistributable firmware is enabled so Wi-Fi, Bluetooth and GPUs work on
#     real laptops.
#
# NVIDIA proprietary is NOT enabled here on purpose: it needs unfree drivers,
# kernel modules and (usually) a manual choice between open/legacy. Hosts with
# an NVIDIA GPU should import ./nvidia.nix instead.
{
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # VA-API (iHD), Broadwell (Gen8) and newer
      intel-vaapi-driver # VA-API (i965), Gen4–9 (Sandy/Ivy Bridge, ...)
      libvdpau-va-gl # VDPAU over OpenGL (video playback)
    ];
  };

  environment.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto"; # Electron apps: pick the right backend
    NIXOS_OZONE_WL = "1"; # Electron apps: Wayland
  };
}
