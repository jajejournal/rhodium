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
    default = false;
    description = ''
      Boot straight into the desktop session, without a login prompt.
      Off by default: the greeter asks for the password on every boot.
    '';
  };

  config.services.greetd = {
    enable = true;
    settings = {
      # Login prompt (tuigreet), shown on boot unless rhodium.autologin is on.
      # It is also what you get back after logging out.
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
