{
  # Launcher entries for the rice's own menus (fuzzel-apps.sh, raffi) and for
  # the generic app menu (Mod + A). Notes:
  #   - `noDisplay = true;` hides an entry from the generic app menu. Use it
  #     for entries that only duplicate the .desktop file the package already
  #     installs, so the app is not listed twice.
  #   - Entries that open a TUI (kitty -e ...) use `utilities-terminal`, since
  #     the icon theme has no icon for e.g. btop, yazi or nu.
  editors = {
    editor-instance = {
      binary = "kitty";
      args = [
        "-e"
        "nvim"
      ];
      icon = "utilities-terminal";
      description = "Editor";
    };
    helix-instance = {
      binary = "kitty";
      args = [
        "-e"
        "hx"
      ];
      icon = "utilities-terminal";
      description = "Helix";
    };
    nvim-instance = {
      binary = "kitty";
      args = [
        "-e"
        "nvim"
      ];
      icon = "utilities-terminal";
      description = "Neovim";
    };
    zeditor = {
      binary = "zeditor";
      args = [ ];
      icon = "zeditor";
      description = "Zeditor";
      noDisplay = true;
    };
    code = {
      binary = "code";
      args = [ ];
      icon = "code";
      description = "VS Code";
      noDisplay = true;
    };
    emacs = {
      binary = "doom";
      args = [ "emacs" ];
      icon = "emacs";
      description = "Doom Emacs";
    };
    texmaker = {
      binary = "texmaker";
      args = [ ];
      icon = "texmaker";
      description = "Texmaker LaTeX Editor";
      noDisplay = true;
    };
    rstudio = {
      binary = "rstudio";
      args = [ ];
      icon = "rstudio";
      description = "RStudio IDE";
      noDisplay = true;
    };
  };

  viewers = {
    # image-viewer-xorg = {
    #   binary = "feh";
    #   args = ["-Z" "--scale-down" "--auto-zoom" "--image-bg" "black" "%f"];
    #   icon = "feh";
    #   description = "Image Viewer (X11)";
    # };
    # image-viewer = {
    #   binary = "imv";
    #   args = [ ];
    #   icon = "imv";
    #   description = "Image Viewer (Wayland)";
    # };
    image-viewer = {
      binary = "oculante";
      args = [ ];
      icon = "oculante";
      description = "Image Viewer (Wayland)";
      noDisplay = true;
    };
  };

  system = {
    bottom = {
      binary = "kitty";
      args = [
        "-e"
        "btm"
      ];
      icon = "utilities-terminal";
      description = "Bottom (Htop)";
    };
    btop = {
      binary = "kitty";
      args = [
        "-e"
        "btop"
      ];
      icon = "utilities-terminal";
      description = "Btop Resource Monitor";
    };
  };

  productivity = {
    yazi = {
      binary = "kitty";
      args = [
        "-e"
        "yazi"
      ];
      icon = "utilities-terminal";
      description = "Yazi in Kitty";
    };
    calcure = {
      binary = "kitty";
      args = [
        "-e"
        "calcure"
      ];
      icon = "utilities-terminal";
      description = "Calcure Calendar and Tasks";
    };
    qalc = {
      binary = "kitty";
      args = [
        "-e"
        "qalc"
      ];
      icon = "utilities-terminal";
      description = "Qalculate CLI";
    };
    qalculate = {
      binary = "qalculate-gtk";
      args = [ ];
      icon = "qalculate";
      description = "Qalculate!";
      noDisplay = true;
    };
    qbittorrent = {
      binary = "qbittorrent";
      args = [ ];
      icon = "qbittorrent";
      description = "qBittorrent";
      noDisplay = true;
    };
    slack = {
      binary = "slack";
      args = [ ];
      icon = "slack";
      description = "Slack";
      noDisplay = true;
    };
    jitsimeet = {
      binary = "jitsi-meet";
      args = [ ];
      icon = "jitsi-meet";
      description = "Jitsi Meet";
      noDisplay = true;
    };
    zoomus = {
      binary = "zoom-us";
      args = [ ];
      icon = "zoom-us";
      description = "Zoom";
      noDisplay = true;
    };
    thunar = {
      binary = "thunar";
      args = [ ];
      icon = "thunar";
      description = "Thunar File Manager";
      noDisplay = true;
    };
    onepassword = {
      binary = "1password";
      # NOTE: Use flags below if not using xwayland-satellite
      # args = ["--enable-features=UseOzonePlatform" "--ozone-platform=wayland"];
      # NOTE: Use flag below if using xwayland-satellite > 0.6
      # args = ["--force-device-scale-factor=1.5"];
      # NOTE: Use no flags for latest beta release
      # NOTE: This is only possible with env var: ELECTRON_OZONE_PLATFORM_HINT = "auto";
      args = [ ];
      icon = "1password";
      description = "1Password";
    };
    bitwarden = {
      binary = "bitwarden";
      args = [ ];
      icon = "bitwarden";
      description = "Bitwarden";
      noDisplay = true;
    };
    # protonpassword = {
    #   binary = "proton-pass";
    #   args = [];
    #   icon = "proton";
    #   description = "ProtonPass";
    # };
    protonvpn = {
      binary = "protonvpn-app";
      args = [ ];
      icon = "proton";
      description = "ProtonVPN GUI";
      noDisplay = true;
    };
    protonmail = {
      binary = "proton-mail";
      args = [ ];
      icon = "protonmail";
      description = "ProtonMail";
      noDisplay = true;
    };
    libreofficewriter = {
      binary = "libreoffice";
      args = [ "--writer" ];
      icon = "libreoffice";
      description = "LibreOffice Writer";
    };
    libreofficecalc = {
      binary = "libreoffice";
      args = [ "--calc" ];
      icon = "libreoffice";
      description = "LibreOffice Calc";
    };
    libreofficedraw = {
      binary = "libreoffice";
      args = [ "--draw" ];
      icon = "libreoffice";
      description = "LibreOffice Draw";
    };
    libreofficeimpress = {
      binary = "libreoffice";
      args = [ "--impress" ];
      icon = "libreoffice";
      description = "LibreOffice Impress";
    };
    libreofficebase = {
      binary = "libreoffice";
      args = [ "--base" ];
      icon = "libreoffice";
      description = "LibreOffice Base";
    };
    libreofficeglobal = {
      binary = "libreoffice";
      args = [ "--global" ];
      icon = "libreoffice";
      description = "LibreOffice Global Document";
    };
    libreofficemath = {
      binary = "libreoffice";
      args = [ "--math" ];
      icon = "libreoffice";
      description = "LibreOffice Math";
    };
    libreofficeweb = {
      binary = "libreoffice";
      args = [ "--web" ];
      icon = "libreoffice";
      description = "LibreOffice HTML Document";
    };
    standardnotes = {
      binary = "standardnotes";
      # NOTE: The flags below are required to work outside X11 (e.g., niri)
      args = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
      ];
      # NOTE: The flags below are required to work in hyprland
      # args = ["--force-device-scale-factor=1.5"];
      icon = "standardnotes";
      description = "Standard Notes";
    };
    teams = {
      binary = "teams-for-linux";
      args = [ ];
      icon = "teams";
      description = "Teams";
      noDisplay = true;
    };
    zen = {
      binary = "zen";
      args = [ ];
      icon = "zen";
      description = "Zen Browser";
      noDisplay = true;
    };
    obsidian = {
      binary = "obsidian";
      args = [ ];
      icon = "obsidian";
      description = "Obsidian";
      noDisplay = true;
    };
    brave = {
      binary = "brave";
      args = [ ];
      icon = "brave";
      description = "Brave";
      noDisplay = true;
    };
    firefox-incognito = {
      binary = "firefox";
      args = [ "--private-window" ];
      icon = "firefox";
      description = "Firefox Incognito";
    };
  };

  social = {
    signal-desktop = {
      binary = "signal-desktop";
      args = [ ];
      icon = "signal";
      description = "Signal Desktop";
      noDisplay = true;
    };
    telegram-desktop = {
      binary = "telegram-desktop";
      args = [ ];
      icon = "telegram";
      description = "Telegram Desktop";
      noDisplay = true;
    };
    discord = {
      binary = "vesktop";
      args = [ ];
      icon = "discord";
      description = "Discord";
      noDisplay = true;
    };
    discordo = {
      binary = "kitty";
      args = [
        "-e"
        "discordo"
      ];
      icon = "utilities-terminal";
      description = "Discord TUI";
    };
    element-call = {
      binary = "element-call";
      args = [ ];
      icon = "element";
      description = "Element Call (Matrix)";
      noDisplay = true;
    };
    fluffychat = {
      binary = "fluffychat";
      args = [ ];
      icon = "fluffychat";
      description = "Fluffychat (Matrix)";
      noDisplay = true;
    };
    mastodon = {
      binary = "mastodon";
      args = [ ];
      icon = "mastodon";
      description = "Mastodon Client";
      noDisplay = true;
    };
  };

  media = {
    spotify = {
      binary = "spotify";
      args = [ ];
      icon = "spotify";
      description = "Spotify GUI";
      noDisplay = true;
    };
    ncspot = {
      binary = "kitty";
      args = [
        "-e"
        "ncspot"
      ];
      icon = "utilities-terminal";
      description = "Spotify TUI";
    };
    gimp = {
      binary = "gimp";
      args = [ ];
      icon = "gimp";
      description = "GIMP";
      noDisplay = true;
    };
    inkscape = {
      binary = "inkscape";
      args = [ ];
      icon = "inkscape";
      description = "InkScape";
      noDisplay = true;
    };
    obs = {
      binary = "obs";
      args = [ ];
      icon = "obs";
      description = "OBS Studio";
      noDisplay = true;
    };
    plexamp = {
      binary = "plexamp";
      args = [ ];
      icon = "plexamp";
      description = "Plexamp";
      noDisplay = true;
    };
  };

  terminals = {
    kitty-instance = {
      binary = "kitty";
      args = [ ];
      icon = "kitty";
      description = "Kitty";
      noDisplay = true;
    };
    foot-instance = {
      binary = "foot";
      args = [ ];
      icon = "foot";
      description = "Foot";
      noDisplay = true;
    };
    ghostty-instance = {
      binary = "env GTK_THEME=Adwaita:dark ghostty";
      args = [ ];
      icon = "ghostty";
      description = "Ghostty";
      extraDesktopArgs = [ "StartupWMClass=ghostty" ];
      noDisplay = true;
    };
  };

  shells = {
    bash-shell = {
      binary = "kitty";
      args = [
        "-e"
        "bash"
      ];
      icon = "utilities-terminal";
      description = "Bash Shell";
    };
    zsh-shell = {
      binary = "kitty";
      args = [
        "-e"
        "zsh"
      ];
      icon = "utilities-terminal";
      description = "Zsh Shell";
    };
    fish-shell = {
      binary = "kitty";
      args = [
        "-e"
        "fish"
      ];
      icon = "utilities-terminal";
      description = "Fish Shell";
    };
    nu-shell = {
      binary = "kitty";
      args = [
        "-e"
        "nu"
      ];
      icon = "utilities-terminal";
      description = "Nu Shell";
    };
  };

  gaming = {
    steam = {
      binary = "steam";
      args = [ ];
      icon = "steam";
      description = "Steam";
      noDisplay = true;
    };
  };

  multiplexers = {
    tmux-session = {
      binary = "kitty";
      args = [
        "-e"
        "tmux"
      ];
      icon = "utilities-terminal";
      description = "Tmux Session";
    };
    zellij = {
      binary = "kitty";
      args = [
        "-e"
        "zellij"
      ];
      icon = "utilities-terminal";
      description = "Zellij Session";
    };
  };
}
