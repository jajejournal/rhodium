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
    ../../modules/desktop/wm/niri/generic.nix
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
  networking = {
    hostName = host.hostname or "nixos";
    networkmanager.enable = true;
  };

  # Modules
  # ---------------------------------
  # Hardware/server services are OFF by default so this builds anywhere.
  extraServices = {
    asusKeyboardBacklight.enable = false;
    laptopLid.enable = true;
    avahi.enable = true;
    plex.enable = false;
    roon.enable = false;
    atuinSync.enable = false;
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

  # VM / Memory tuning
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
  system.stateVersion = host.stateVersion or "25.11";
}
