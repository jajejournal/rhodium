{ pkgs, host, ... }:
# NOTE: Keyboard layout, timezone and locale are configurable per host in
#       data/hosts/hosts.nix (fields: timeZone / locale).
let
  timeZone = host.timeZone or "Europe/Madrid";
  locale = host.locale or "en_US.UTF-8";
in
{
  environment.systemPackages = with pkgs; [
    xorg.xev # xorg key registry
  ];

  time.timeZone = timeZone; # Time zone
  i18n.defaultLocale = locale; # Locale

  # Additional properties
  i18n.extraLocaleSettings = {
    LC_ADDRESS = locale;
    LC_IDENTIFICATION = locale;
    LC_MEASUREMENT = locale;
    LC_MONETARY = locale;
    LC_NAME = locale;
    LC_NUMERIC = locale;
    LC_PAPER = locale;
    LC_TELEPHONE = locale;
    LC_TIME = locale;
  };

  console.keyMap = "us"; # TTY console keymap

  # X11/XWayland layouts: English (US) + Spanish, toggled with Super+Space.
  # Niri sets the Wayland layout separately (home/desktop/wm/niri/).
  services.xserver.xkb = {
    layout = "us,es";
    options = "grp:win_space_toggle";
    variant = "";
  };

  # NOTE: Required for kmonad
  hardware.uinput = {
    enable = true;
  };
}
