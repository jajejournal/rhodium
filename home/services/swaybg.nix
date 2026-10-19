{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.userExtraServices.rh-swaybg;
  targetDir = "/var/tmp/current-wallpaper";
  # First-boot / out-of-the-box wallpaper. `switch_wallpaper` (fuzzel-display)
  # overwrites the /var/tmp symlink whenever the user picks another one.
  defaultWallpaper = "${config.xdg.dataHome}/wallpapers/bebop/bebop.jpg";
  # Seed the /var/tmp symlink with the default wallpaper only when it does not
  # already resolve to a file (first boot, or the chosen one was deleted).
  seedWallpaper = pkgs.writeShellScript "rh-swaybg-seed" ''
    test -e ${targetDir} || ${pkgs.coreutils}/bin/ln -sf ${defaultWallpaper} ${targetDir}
  '';
in
{
  options.userExtraServices.rh-swaybg = {
    enable = mkEnableOption "Wallpaper tool for Wayland compositors";
  };

  config = mkIf cfg.enable {
    systemd.user.services.rh-swaybg = {
      Unit = {
        Description = "Wallpaper daemon for Wayland";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session-pre.target" ];
      };

      Service = {
        Type = "simple";
        ExecStartPre = [ "${seedWallpaper}" ];
        ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i ${targetDir}";
        Restart = "on-failure";
        RestartSec = 1;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
