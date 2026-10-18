{
  # ───────────────────────────────────────────────────────────────────────────
  # Host registry
  # ───────────────────────────────────────────────────────────────────────────
  # Each key here must match:
  #   - a directory name under ./hosts        (e.g. hosts/amd/default.nix)
  #   - a nixosConfiguration attribute        (e.g. `nixos-rebuild switch --flake .#amd`)
  #
  #   hostname    -> networking.hostName
  #   user        -> key in data/users/users.nix that this host logs in as
  #   gpu         -> informational; pick the matching niri module in hosts/<key>
  #   timeZone    -> time.timeZone (e.g. "America/Bogota", "Europe/Madrid")
  #   locale      -> i18n.defaultLocale (keep English, e.g. "en_US.UTF-8")
  #   mainMonitor -> primary display defaults (used by niri/waybar)
  # ───────────────────────────────────────────────────────────────────────────
  hosts = {
    amd = {
      hostname = "amd";
      description = "AMD Host";
      user = "user_amd";
      gpu = "amd";
      timeZone = "America/Bogota";
      locale = "en_US.UTF-8";
      mainMonitor = {
        monitorID = "eDP-1";
        monitorResolution = "1920x1080";
        monitorRefreshRate = "60";
        monitorScalingFactor = "1.0";
      };
      defaultLocale = "";
    };

    intel = {
      hostname = "intel";
      description = "Intel Host";
      user = "user_intel";
      gpu = "intel";
      timeZone = "America/Bogota";
      locale = "en_US.UTF-8";
      mainMonitor = {
        monitorID = "eDP-1";
        monitorResolution = "1920x1080";
        monitorRefreshRate = "60";
        monitorScalingFactor = "1.0";
      };
      defaultLocale = "";
    };
  };
}
