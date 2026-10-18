{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.rh.apps.media.audio.roon;
in
{
  # ───────────────────────────────────────────────────────────────────────────
  # Roon — OFF by default.
  #
  # Both packages only make sense next to a running Roon Server, which is a
  # paid product. More importantly, `roon-bridge` is NOT free software
  # (`license = unfree`): it downloads a proprietary binary from Roon's
  # servers *at build time*, so it breaks the build whenever Roon takes an
  # old version down (404) — which is exactly what happened on a fresh
  # install. Keeping it opt-in keeps the flake installable anywhere.
  #
  # Enable it in users/<your user>/ if you actually run a Roon Server.
  # ───────────────────────────────────────────────────────────────────────────
  options.rh.apps.media.audio.roon = {
    enable = lib.mkEnableOption "roon-tui, a Roon remote for the terminal";

    withBridge = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Also install roon-bridge, Roon's audio output endpoint.

        WARNING: it is a proprietary binary fetched from Roon's servers at
        build time, so it can break the whole build when Roon removes a
        version. Leave it off unless you know you need it.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        roon-tui # TUI remote control for Roon (MIT)
      ]
      ++ lib.optionals cfg.withBridge [
        roon-bridge # Roon audio output endpoint (unfree, fetched at build time)
      ];
  };
}
