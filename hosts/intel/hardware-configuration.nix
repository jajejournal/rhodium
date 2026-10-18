# ─────────────────────────────────────────────────────────────────────────────
# HARDWARE CONFIGURATION — TEMPLATE (regenerate on the target machine!)
# ─────────────────────────────────────────────────────────────────────────────
# This file is machine-specific: it describes disks, kernel modules and
# firmware for ONE computer. The original repo shipped the real files for the
# author's laptops, which will NOT boot on your hardware.
#
# BEFORE THE FIRST INSTALL, on the machine you are installing to, run:
#
#   sudo nixos-generate-config --root /mnt
#
# then copy the generated file over this one:
#
#   sudo cp /mnt/etc/nixos/hardware-configuration.nix \
#           ~/rhodium/hosts/intel/hardware-configuration.nix
#
# Everything below is a generic starting point (UEFI + systemd-boot, ext4 root).
# ─────────────────────────────────────────────────────────────────────────────
{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];

  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # NOTE: Regenerating the file will replace these with real UUIDs.
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  powerManagement.cpuFreqGovernor = "performance";
}
