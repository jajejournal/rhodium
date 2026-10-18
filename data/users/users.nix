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
  };
}
