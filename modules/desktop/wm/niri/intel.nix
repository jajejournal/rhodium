{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./base.nix
  ];

  # ───────────────────────────────────────────────────────────────────────────
  # Niri on Intel integrated graphics (i915 / xe). No proprietary drivers.
  # If your machine also has a dedicated NVIDIA GPU, import ./nvidia.nix instead
  # (or in addition) from your host module.
  # ───────────────────────────────────────────────────────────────────────────

  boot.kernelModules = [ "kvm-intel" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # VA-API (Broadwell and newer)
      vpl-gpu-rt # oneVPL runtime (Tiger Lake and newer)
      libvdpau-va-gl # VDPAU over OpenGL
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD"; # Use Intel Media Driver for VA-API
    ELECTRON_OZONE_PLATFORM_HINT = "auto"; # Electron app flickering fix
    NIXOS_OZONE_WL = "1"; # Auto configure Electron apps for Wayland
  };
}
