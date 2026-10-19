{
  # ───────────────────────────────────────────────────────────────────────────
  # User registry
  # ───────────────────────────────────────────────────────────────────────────
  # Each entry describes ONE Linux user. Which user a machine uses is decided
  # by the `user` field of its host in data/hosts/hosts.nix.
  #
  # NOTE: `username` becomes /home/<username>, the Home Manager user and the
  # autologin name, so it MUST be a valid Linux username (lowercase, no spaces).
  # ───────────────────────────────────────────────────────────────────────────
  users = {
    user_amd = {
      username = "bausserr";
      fullName = "Julian";
      emailMain = "jajejournal@users.noreply.github.com";
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
        "input"
        "uinput"
        "video"
      ]; # NOTE: uinput is required by kmonad
      isNormalUser = true;
      shell = "fish";
    };

    user_intel = {
      username = "manssell";
      fullName = "Julian";
      emailMain = "jajejournal@users.noreply.github.com";
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
        "input"
        "uinput"
        "video"
      ]; # NOTE: uinput is required by kmonad
      isNormalUser = true;
      shell = "fish";
    };

    # Generic host user. Create this user (default "rhodium") in the NixOS
    # installer, or change `username` to whatever you created.
    user_generic = {
      username = "rhodium";
      fullName = "Rhodium";
      emailMain = "rhodium@users.noreply.github.com";
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
        "input"
        "uinput"
        "video"
      ];
      isNormalUser = true;
      shell = "fish";
    };
  };
}
