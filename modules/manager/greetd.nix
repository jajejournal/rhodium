{
  pkgs,
  lib,
  config,
  users,
  host,
  ...
}:
let
  # Which user this host logs in as (see data/hosts/hosts.nix -> `user`).
  userKey = host.user or (builtins.head (builtins.attrNames users));
  userName = (users.${userKey} or { username = "nixos"; }).username;
in
{
  options.rhodium.autologin = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Boot straight into the desktop session without a login prompt.";
  };

  config.services.greetd = {
    enable = true;
    settings = {
      # Fallback greeter: shown when autologin is disabled, or after logging out.
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${pkgs.niri}/bin/niri-session";
        user = "greeter";
      };
    }
    // lib.optionalAttrs config.rhodium.autologin {
      # Autologin: start the niri session directly on boot.
      initial_session = {
        command = "${pkgs.niri}/bin/niri-session";
        user = userName;
      };
    };
  };
}
