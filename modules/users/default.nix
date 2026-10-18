{
  pkgs,
  lib,
  users,
  host,
  ...
}:
let
  # Resolve which user this host logs in as. The mapping lives in
  # data/hosts/hosts.nix (`user = "user_xxx";`). Falls back to the first
  # defined user so the flake still evaluates if a host forgets the field.
  userKey = host.user or (builtins.head (builtins.attrNames users));

  user_001_data =
    users.${userKey} or {
      username = "user";
      fullName = "Default User";
      emailMain = "user@example.com";
      description = "Default User";
      extraGroups = [ "wheel" ];
    };
in
{
  users.users."${user_001_data.username}" = {
    name = user_001_data.username;
    isNormalUser = user_001_data.isNormalUser or true;
    description = user_001_data.fullName;
    extraGroups = user_001_data.extraGroups;
    shell = pkgs.fish;
    home = "/home/${user_001_data.username}";
    # Uncomment and paste YOUR OWN public key to log in over SSH:
    # openssh.authorizedKeys.keys = [
    #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... you@machine"
    # ];
  };

  # NOTE: Required for devenv
  nix.settings.trusted-users = [
    "root"
    "${user_001_data.username}"
  ];

  home-manager.backupFileExtension = "backup"; # HACK: Required since hm activation was sometimes faulty

  users.defaultUserShell = pkgs.zsh; # Default shell for all users
}
