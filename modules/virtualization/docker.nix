{
  config,
  pkgs,
  ...
}:
{
  # Generic Docker (no GPU passthrough). Used by hosts that don't need the
  # AMD/NVIDIA specific variants.
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };
}
