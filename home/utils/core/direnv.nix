{ config, ... }:
{
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true; # Cache .env environment
    silent = true; # Silence direnv messages

    config = {
      # Whitelist configuration
      # NOTE: any PRE-approved `.envrc` under this prefix runs automatically.
      # The rice's own repo lives here (see INSTALL.md), and its .envrc is just
      # `use flake`, so cd'ing into it loads the dev shell without asking.
      # Clones elsewhere need a one-time `direnv allow`.
      whitelist = {
        # Allow entire directory hierarchies
        prefix = [
          "${config.home.homeDirectory}/rhodium"
        ];
      };

      warn_timeout = "10s"; # Warning timeout
      disable_stdin = true; # Disable stdin during .envrc evaluation
    };
  };
}
