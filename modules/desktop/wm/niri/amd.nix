{ pkgs, ... }:
# ───────────────────────────────────────────────────────────────────────────
# Niri on AMD graphics (Mesa RADV/radeonsi, free drivers).
# ───────────────────────────────────────────────────────────────────────────
{
  imports = [
    ./base.nix
    ./gpu.nix
  ];

  environment.systemPackages = with pkgs; [
    radeontop
  ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1"; # For invisible cursors
    AMD_VULKAN_ICD = "RADV";
  };
}
