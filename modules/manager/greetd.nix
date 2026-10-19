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

  config = {
    # The RHODIUM wordmark. tuigreet reads /etc/issue (`--issue`) and paints it
    # with the "greet" color, so this is the red logo you see on the login
    # prompt. agetty shows the same file on the plain console logins, hence the
    # plain text: keep it free of escapes.
    #
    # NixOS fills /etc/issue from services.getty.greetingLine and wraps it in
    # ANSI escapes, which would fight with the greeter's own theming, so we
    # write the file directly (overriding that default). Same art as the neovim
    # dashboard.
    environment.etc."issue".text = ''
      ╦═══╗┬   ┬┌───┐ ┌┬─┐┬┬   ┬┌─┬─┐
      ║   ║│   ││   │  │ │││   ││ │ │
      ╠═╦═╝├───┤│   │  │ │││   ││ │ │
      ║ ║  │   ││   │  │ │││   ││ │ │
      ╩ ╚══┴   ┴└───┘──┴─┘┴└───┘┴   ┴
    '';

    services.greetd = {
      enable = true;
      settings = {
        # Login prompt (tuigreet), shown on boot unless rhodium.autologin is on.
        # It is also what you get back after logging out.
        #
        # --issue                 show /etc/issue (the logo above) on top
        # --theme 'greet=red;...' paint it (and the frame) in the rice's red
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --issue --time --theme 'greet=red;border=red' --cmd ${pkgs.niri}/bin/niri-session";
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
  };
}
