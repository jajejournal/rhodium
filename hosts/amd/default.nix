{
  host,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot/boot.nix
    ../../modules/services
    ../../modules/hardware
    ../../modules/shell
    ../../modules/security
    ../../modules/users
    ../../modules/manager
    ../../modules/desktop
    ../../modules/desktop/wm/niri/amd.nix
    ../../modules/integration
    ../../modules/virtualization
    ../../modules/virtualization/docker-amd.nix
    ../../modules/apps
    ../../modules/gaming/steam.nix
    ../../modules/rules
    ../../modules/maintenance
    ../../modules/utils
    ../../modules/network
  ];

  # Base
  # ---------------------------------
  # Kernel: nixpkgs' default LTS choice. Uncomment to pin a specific series.
  # boot.kernelPackages = pkgs.linuxPackages_6_12;

  # Host Configuration
  networking = {
    hostName = host.hostname or "nixos";
    networkmanager.enable = true;
  };

  # Modules
  # ---------------------------------
  # Display Manager (greetd is used; GDM off)
  manager = {
    gdm.enable = false;
  };

  # Extra Services
  # NOTE: hardware-specific services are OFF by default so this builds on any
  #       machine. Turn them ON only if your hardware matches.
  extraServices = {
    asusKeyboardBacklight.enable = false; # ASUS laptops only
    laptopLid.enable = true; # generic laptop lid behavior
  };

  # Extra rules (all device-specific; enable the ones you actually own)
  extraRules = {
    keychronUdev.enable = false; # Keychron V1 keyboard
    keychronQ3Udev.enable = false; # Keychron Q3 keyboard
    hdmiAutoSwitch.enable = false; # auto-switch on HDMI hotplug
    netgearA8000Udev.enable = false; # NETGEAR A8000 USB WiFi
    bluetoothNoPowerSave.enable = true;
  };

  # Garbage collection
  maintenance.garbageCollection = {
    enable = true;
    schedule = "daily";
    deleteOlderThan = "30d";
  };

  # VM / Memory tuning
  # ---------------------------------
  boot.kernel.sysctl = {
    "vm.swappiness" = 10; # Strongly prefer RAM over swap
    "vm.vfs_cache_pressure" = 50; # Keep dentries/inodes cached longer
  };

  # Compressed in-memory swap (much faster than disk swap)
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd";
    priority = 100;
  };

  # ───────────────────────────────────────────────────────────────────────────
  # EXAMPLE: ASUS-specific power management (disabled).
  # Uncomment if you have an ASUS laptop and want per-AC-profile tuning.
  # ───────────────────────────────────────────────────────────────────────────
  # services.udev.extraRules = ''
  #   ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="1", \
  #     RUN+="${pkgs.bash}/bin/bash -c 'echo performance > /sys/firmware/acpi/platform_profile'"
  #   ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="0", \
  #     RUN+="${pkgs.bash}/bin/bash -c 'echo balanced > /sys/firmware/acpi/platform_profile'"
  # '';

  # Extra Args
  # ---------------------------------
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = host.stateVersion or "24.05";
}
