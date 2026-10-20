{
  apps = {
    # Core
    shell = "fish";
    shelAlt = "zsh";
    terminal = "kitty";
    terminalAlt = "ghostty";
    browser = "firefox";
    browserAlt = "brave";
    wm = "niri";

    # Files
    editor = "nvim";
    editorAlt = "hx";
    ide = "zeditor";
    ideAlt = "code";
    filesTerminal = "yazi";
    filesGraphic = "thunar";

    # Media
    imageViewer = "imv";
    videoPlayer = "mpv";
    audioPlayer = "mpv";

    # Productivity
    pdfViewer = "org.pwmt.zathura";
    pager = "most";
  };

  # Profile names inside each browser. The keys are the profile ids referenced
  # by data/users/extras/bookmarks.nix and data/users/extras/profiles.nix.
  # firefox.personal is required: home/environment/mime.nix points web links
  # at that profile's launcher entry (rh-firefox-personal). Add the profiles
  # you actually use; every key becomes available to bookmarks and launchers.
  profiles = {
    firefox = {
      # Empty = the browser's default profile, so links and launcher entries
      # work on a fresh install. Put a profile name here (e.g. "Personal",
      # created in about:profiles) to route them through that profile.
      personal = "";
    };
  };
}
