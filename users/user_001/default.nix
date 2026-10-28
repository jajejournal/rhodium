{
  inputs,
  pkgs,
  userData,
  theme,
  userExtras,
  rhodiumLib,
  userPreferences,
  host,
  user,
  ...
}:
{
  imports = [
    # External flakes
    inputs.rhodium-opencode.homeManagerModules.default

    # Themes
    ../../home/assets/themes

    # Extra Modules
    ../../home/environment
    ../../home/modules
    ../../home/services

    # Main Modules
    ../../home/apps
    ../../home/desktop
    ../../home/development
    ../../home/security
    ../../home/shells
    ../../home/system
    ../../home/utils
    ../../home/virtualization
  ];

  # Pass args to all modules
  _module.args = {
    inherit
      userExtras
      userPreferences
      rhodiumLib
      host
      ;
  };

  # --- Theme Configuration ---
  # TODO: Finish this
  theme = theme;

  # Asset linking
  # TODO: Add semantic layer so we have clarity that this is a Rhodium module
  assets = {
    wallpapers.enable = true; # Symlink wallpapers to data dir
    colors.enable = true; # Symlink color packs to user data dir
    icons.enable = true; # Symlink icon packs to user data dir
    ascii.enable = true; # Symlink ASCII art files to user data dir
  };

  # Script linking
  # WARN: Enables all scripts in home/scripts with chmod +x
  scripts = {
    enable = true;
  };

  # Custom services
  # NOTE: These are custom services located under home/services, and run as systemd daemons
  userExtraServices = {
    rh-brave-preload.enable = true; # vmtouch: lock Brave binaries in RAM for instant startup
    rh-eww.enable = false;
    rh-firefox-preload.enable = true; # vmtouch: lock Firefox binaries in RAM for instant startup
    rh-kmonad.enable = false; # NOTE: enable only if you own the supported Keychron keyboards
    rh-mako.enable = false;
    rh-neovim-daemon.enable = false;
    rh-swaybg.enable = true;
    rh-system-keyring.enable = true;
    rh-waybar.enable = false;
    # These helpers are hardware-specific, wlroots-only and their udev rules are
    # disabled on the current hosts. Keep them off unless the matching hardware
    # and compositor setup is present.
    rh-wifiSwitch.enable = false;
    rh-wlsunset.enable = false;
    rh-hdmiAutoSwitch.enable = false;
  };

  # --- Rh Home Modules ---
  rh = {
    apps.media.audio = {
      roon.enable = false; # NOTE: Roon is paid + roon-bridge breaks builds; see home/apps/media/audio/roon.nix
    };
    development.languages = {
      haskell.enable = true;
    };
  };

  # --- User Config ---
  home = {
    username = user.username;
    homeDirectory = "/home/${user.username}";
    stateVersion = "25.05";
  };
}
