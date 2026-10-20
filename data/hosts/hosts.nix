{
  # ───────────────────────────────────────────────────────────────────────────
  # Host registry
  # ───────────────────────────────────────────────────────────────────────────
  # Each key here must match:
  #   - a directory name under ./hosts        (e.g. hosts/amd/default.nix)
  #   - a nixosConfiguration attribute        (e.g. `nixos-rebuild switch --flake .#amd`)
  #
  #   hostname      -> networking.hostName
  #   user          -> key in data/users/users.nix that this host logs in as
  #   gpu           -> informational; pick the matching module in hosts/<key>
  #                    ("intel" | "amd" | "nvidia" | "generic")
  #   battery       -> OPTIONAL waybar battery name (default "BAT0")
  #   hasNvme       -> OPTIONAL, show the NVMe temperature in the bar (default false)
  #   timeZone      -> time.timeZone (e.g. "America/Bogota", "Europe/Madrid")
  #   locale        -> i18n.defaultLocale (keep English, e.g. "en_US.UTF-8")
  #   mainMonitor   -> primary display (used by niri/waybar)
  #   extraMonitors -> OPTIONAL list of extra displays, laid out to the right of
  #                    the main one. Empty/omitted = a normal laptop with a
  #                    single screen. Each entry uses the same keys as
  #                    mainMonitor plus an optional `monitorRotation` (degrees).
  #
  # Nothing here is machine-bound except the monitor list, so a fresh install
  # works by regenerating hosts/<h>/hardware-configuration.nix and (optionally)
  # editing the monitors below.
  # ───────────────────────────────────────────────────────────────────────────
  hosts = {
    amd = {
      hostname = "amd";
      description = "AMD Host";
      user = "user_amd";
      gpu = "amd";
      battery = "BAT1";
      hasNvme = true;
      timeZone = "America/Bogota";
      locale = "en_US.UTF-8";
      mainMonitor = {
        monitorID = "eDP-1";
        monitorResolution = "1920x1080";
        monitorRefreshRate = "60";
        monitorScalingFactor = "1.0";
      };
      extraMonitors = [ ];
    };

    intel = {
      hostname = "intel";
      description = "Intel Host";
      user = "user_intel";
      gpu = "intel";
      battery = "BAT0";
      hasNvme = false;
      timeZone = "America/Bogota";
      locale = "en_US.UTF-8";
      mainMonitor = {
        monitorID = "LVDS-1";
        monitorResolution = "1366x768";
        monitorRefreshRate = "59.978";
        monitorScalingFactor = "1.0";
      };
      extraMonitors = [ ];
    };

    # ─────────────────────────────────────────────────────────────────────────
    # Generic host — use this one on a brand-new PC.
    # ─────────────────────────────────────────────────────────────────────────
    # It installs the free GPU drivers for Intel + AMD and auto-detects the
    # rest, so it boots and renders on nearly any machine. Steps for a new PC:
    #
    #   1. Create the `rhodium` user in the installer (or change `user` below).
    #   2. Regenerate hosts/generic/hardware-configuration.nix.
    #   3. `just switch generic`.
    #
    # If the machine has an NVIDIA GPU, add the nvidia.nix import in
    # hosts/generic/default.nix and set gpu = "nvidia".
    generic = {
      hostname = "nixos";
      description = "Generic / any PC";
      user = "user_generic";
      gpu = "generic";
      battery = "BAT0";
      hasNvme = false;
      timeZone = "America/Bogota";
      locale = "en_US.UTF-8";
      mainMonitor = {
        monitorID = "eDP-1";
        monitorResolution = "1920x1080";
        monitorRefreshRate = "60";
        monitorScalingFactor = "1.0";
      };
      extraMonitors = [ ];
    };
  };
}
