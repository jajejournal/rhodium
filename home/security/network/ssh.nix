{ lib, config, ... }:
let
  cfg = config.rhSsh;
in
{
  # ───────────────────────────────────────────────────────────────────────────
  # Optional: install PUBLIC key(s) into ~/.ssh/authorized_keys.
  #
  # Nothing is hardcoded here: if you want your own key, either
  #   - set rhSsh.authorizedKeys = [ "ssh-ed25519 AAAA... you@machine" ]; or
  #   - edit ~/.ssh/authorized_keys manually (unmanaged).
  #
  # NOTE: This only writes PUBLIC keys (safe to commit). NEVER commit private
  # keys (id_ed25519, id_rsa, *.pem, *.key) to the repository.
  # ───────────────────────────────────────────────────────────────────────────
  options.rhSsh.authorizedKeys = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "Public SSH keys to install into ~/.ssh/authorized_keys.";
  };

  config = {
    services.ssh-agent.enable = true;

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        addKeysToAgent = "yes";
        # OPTIONAL: point this at YOUR own private key if you use one.
        # The key itself lives in ~/.ssh (never in the repo).
        # identityFile = [ "~/.ssh/id_ed25519" ];
      };
    };

    home.activation.installAuthorizedKeys = lib.mkIf (cfg.authorizedKeys != [ ]) (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        # ensure ~/.ssh directory exists with correct perms
        mkdir -p "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"

        # write authorized_keys
        : > "$HOME/.ssh/authorized_keys"
        ${lib.concatMapStringsSep "\n" (
          key: ''echo ${lib.escapeShellArg key} >> "$HOME/.ssh/authorized_keys"''
        ) cfg.authorizedKeys}

        # set proper ownership and perms
        chown "$USER":"$(id -gn $USER)" "$HOME/.ssh/authorized_keys"
        chmod 600 "$HOME/.ssh/authorized_keys"
      ''
    );
  };
}
