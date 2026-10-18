{
  config,
  lib,
  ...
}:
{
  # ───────────────────────────────────────────────────────────────────────────
  # opencode — AI coding agent (https://opencode.ai)
  #
  # The package itself is installed in ./default.nix. Here we only drop its
  # config file:  ~/.config/opencode/opencode.json
  #
  # Default model: OpenCode's own FREE model (no API key required):
  #   opencode/deepseek-v4.1-flash-free
  #
  # To add other providers (Anthropic, OpenAI, ...) run:  opencode auth login
  # ───────────────────────────────────────────────────────────────────────────
  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";

    # Default model used when none is passed with --model.
    model = "opencode/deepseek-v4.1-flash-free";

    # Nix owns the binary, so disable self-updating (avoids clobbering the
    # read-only Nix store and version drift).
    autoupdate = false;
  };
}
