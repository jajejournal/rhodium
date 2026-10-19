{
  config,
  pkgs,
  ...
}:
# ───────────────────────────────────────────────────────────────────────────
# Niri on NVIDIA (proprietary). Opt-in: import this from a host that has an
# NVIDIA GPU instead of ./intel.nix or ./amd.nix.
# ───────────────────────────────────────────────────────────────────────────
{
  imports = [
    ./base.nix
    ./gpu.nix
  ];

  # NVIDIA proprietary kernel modules (loaded by the driver itself).
  boot.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  hardware.nvidia = {
    open = true; # Open kernel modules for Turing (RTX 20xx) and later
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = true; # Suspend/resume power management
    modesetting.enable = true;
  };

  hardware.nvidia-container-toolkit = {
    enable = true;
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct"; # Hardware video acceleration
  };

  environment.systemPackages = with pkgs; [
    egl-wayland
    nvidia-vaapi-driver
    libvdpau-va-gl
  ];

  services.xserver.videoDrivers = [ "nvidia" ];
}
