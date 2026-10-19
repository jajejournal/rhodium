{ pkgs, config, ... }:
let
  # Shared styling so the browser follows the rice's theme
  # (see browser-theme.nix).
  browserTheme = import ./browser-theme.nix { theme = config.theme; };
in
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

    # Firefox needs a *managed* profile for Home Manager to be able to install
    # userChrome.css / userContent.css and the preferences. This one is the
    # default ("Personal").
    #
    # NOTE: if you already had browsing data (bookmarks, history, logins) in
    # Firefox's own profile, it stays where it is — the old folder is still in
    # ~/.mozilla/firefox. Copy it over with:
    #   cp -r ~/.mozilla/firefox/<old profile>/ ~/.mozilla/firefox/personal/
    profiles.personal = {
      id = 0;
      name = "Personal";
      isDefault = true;
      settings = browserTheme.firefoxSettings // browserTheme.legacySettings;
      inherit (browserTheme) userChrome userContent;
    };
  };
}
