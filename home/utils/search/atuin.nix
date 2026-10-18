{ host, ... }:
let
  # Point this at your own Atuin server to enable history sync.
  # Set `atuinServerUrl = "http://your-server:8888";` in data/hosts/hosts.nix.
  # Sync is disabled when unset (default), so the shell works out of the box.
  syncUrl = host.atuinServerUrl or null;
  syncEnabled = syncUrl != null;
in
{
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = {
      auto_sync = syncEnabled;
      sync_enabled = syncEnabled;
      sync_address = if syncUrl != null then syncUrl else "";
      sync_frequency = "5m";
      search_mode = "fuzzy";
      filter_mode = "global";
      style = "full";
      show_preview = true;
      show_help = false;
      show_tabs = true;
      inline_height = 25;
      max_preview_height = 10;
      keymap_mode = "vim-insert";
      invert = false;
      enter_accept = false;
      exit_mode = "return-original";
    };
  };
}
