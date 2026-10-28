{
  host,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/apps
    ../../modules/boot/boot.nix
    ../../modules/desktop
    ../../modules/desktop/wm/niri/intel.nix
    ../../modules/hardware
    ../../modules/integration
    ../../modules/maintenance
    ../../modules/manager
    ../../modules/network
    ../../modules/rules
    ../../modules/security
    ../../modules/services
    ../../modules/shell
    ../../modules/users
    ../../modules/utils
    ../../modules/virtualization
    ../../modules/virtualization/docker.nix
    ../../modules/gaming/steam.nix
  ];

  # Base
  # ---------------------------------
  # Kernel: nixpkgs' default LTS choice. Uncomment to pin a specific series.
  # boot.kernelPackages = pkgs.linuxPackages_6_12;

  # Intel WiFi + Bluetooth coexistence fix for audio dropouts
  # Reference: https://wiki.nixos.org/wiki/Bluetooth
  boot.extraModprobeConfig = ''
    options iwlwifi bt_coex_active=0
  '';

  networking = {
    hostName = host.hostname or "nixos";
    networkmanager.enable = true;
  };

  # Modules
  # ---------------------------------
  # NOTE: hardware/server services are OFF by default so this builds anywhere.
  extraServices = {
    asusKeyboardBacklight.enable = false;
    laptopLid.enable = true;
    avahi.enable = true;
    plex.enable = false; # media server (needs an account)
    roon.enable = false; # Roon bridge
    atuinSync.enable = false; # self-hosted Atuin server
  };

  extraRules = {
    keychronUdev.enable = false;
    keychronQ3Udev.enable = false;
    hdmiAutoSwitch.enable = false;
    bluetoothNoPowerSave.enable = true;
  };

  maintenance.garbageCollection = {
    enable = true;
    schedule = "daily";
    deleteOlderThan = "30d";
  };

  # VM / Memory tuning (same defaults as the AMD host)
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd";
    priority = 100;
  };

  # Extra Args
  # ---------------------------------
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = host.stateVersion or "24.11";
}
