{
  pkgs,
  lib,
  config,
  users,
  host,
  ...
}:

with lib;
let
  userKey = host.user or (builtins.head (builtins.attrNames users));
  userName = (users.${userKey} or { username = "nixos"; }).username;
in
{
  options.extraRules.hdmiAutoSwitch.enable = mkEnableOption "Udev rule for HDMI auto-switching";

  config = mkIf config.extraRules.hdmiAutoSwitch.enable {
    services.udev.extraRules = ''
      ACTION=="change", SUBSYSTEM=="drm", ENV{HOTPLUG}=="1", \
        DEVPATH=="*/drm/card1", \
        RUN+="${pkgs.util-linux}/bin/runuser -u ${userName} -- ${pkgs.systemd}/bin/systemctl --user start --no-block rh-hdmi-hotplug.service"
    '';
  };
}
