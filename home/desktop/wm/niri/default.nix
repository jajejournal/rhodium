{
  lib,
  host,
  ...
}:

let
  # Helper to convert string to float (ensures float type even for integer strings)
  toFloat = str: (builtins.fromJSON str) * 1.0;

  # Extract host display configuration
  hostname = host.hostname or "unknown";

  # Main monitor configuration from host data
  mainMonitor =
    host.mainMonitor or {
      monitorID = "eDP-1";
      monitorResolution = "1920x1080";
      monitorRefreshRate = "60";
      monitorScalingFactor = "1.0";
    };

  # Parse resolution to get width and height
  parseResolution =
    resolution:
    let
      parts = lib.splitString "x" resolution;
    in
    {
      width = if (builtins.length parts) >= 1 then lib.toInt (builtins.elemAt parts 0) else 1920;
      height = if (builtins.length parts) >= 2 then lib.toInt (builtins.elemAt parts 1) else 1080;
    };

  resolution = parseResolution mainMonitor.monitorResolution;
  refreshRate = toFloat mainMonitor.monitorRefreshRate;
  scaleFactor = toFloat mainMonitor.monitorScalingFactor;

  # Calculate external monitor positions based on main monitor settings
  # MSI position = main_width / main_scale (logical pixels, right of laptop)
  msiPositionX = builtins.floor (resolution.width / scaleFactor);
  # Dell position = right of MSI (MSI logical width = 3440 at scale 1.0)
  dellPositionX = msiPositionX + 3440;

  # Keybind cheatsheets (see `binds` below and xdg.configFile."niri/shortcuts.txt"
  # at the end of this file):
  #   cheatsheetMenu -> searchable menu, built from the titles in this very
  #                     config so it can never go stale
  #                     (home/scripts/fuzzel/fuzzel-help.sh).
  #   cheatsheetText -> the full plain-text list, which also documents the
  #                     rice's other menus and helper scripts.
  cheatsheetMenu = "~/.local/bin/fuzzel/fuzzel-help.sh";
  cheatsheetText = "kitty --class rh-shortcuts -e less -R \"$HOME/.config/niri/shortcuts.txt\"";
in
{
  programs.niri.settings = {
    # ============================================================================
    # Workspaces
    # ============================================================================
    # Named workspaces pinned to outputs so they survive monitor power off/on.
    # Keys are prefixed for lexicographic ordering; `name` is the display name.
    workspaces = {
      # Laptop
      "01-main" = {
        name = "main";
        open-on-output = "${mainMonitor.monitorID}";
      };
      "02-secondary" = {
        name = "secondary";
        open-on-output = "${mainMonitor.monitorID}";
      };

      # MSI ultrawide (center)
      "03-browser" = {
        name = "browser";
        open-on-output = "Microstep MAG 341C OLED 0x01010101";
      };
      "04-dev" = {
        name = "dev";
        open-on-output = "Microstep MAG 341C OLED 0x01010101";
      };
      "05-media" = {
        name = "media";
        open-on-output = "Microstep MAG 341C OLED 0x01010101";
      };

      # Dell 4K (right, portrait)
      "06-reference" = {
        name = "reference";
        open-on-output = "Dell Inc. DELL U2725QE G3L0G84";
      };
      "07-chat" = {
        name = "chat";
        open-on-output = "Dell Inc. DELL U2725QE G3L0G84";
      };
    };

    # ============================================================================
    # Environment
    # ============================================================================
    # Required for xwayland-satellite X11 app compatibility
    environment = {
      DISPLAY = ":0";
    };

    # ============================================================================
    # Input
    # ============================================================================
    input = {
      keyboard = {
        xkb = {
          layout = "es,us";
          options = "grp:win_space_toggle";
        };
        repeat-delay = 300;
        repeat-rate = 90;
        numlock = true;
      };

      touchpad = {
        dwt = true;
        dwtp = true;
        tap = true;
        natural-scroll = false;
        accel-speed = -0.3;
        middle-emulation = true;
        scroll-factor = 1.0;
        drag = true;
      };

      mouse = {
        accel-speed = 0.1;
        accel-profile = "adaptive";
        scroll-factor = 0.9;
        middle-emulation = true;
      };

      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "90%";
      };

      workspace-auto-back-and-forth = true;
    };

    # ============================================================================
    # Outputs
    # ============================================================================
    outputs = {
      # Main laptop display (dynamic based on host)
      "${mainMonitor.monitorID}" = {
        mode = {
          width = resolution.width;
          height = resolution.height;
          refresh = refreshRate;
        };
        scale = scaleFactor;
        position = {
          x = 0;
          y = 0;
        };
      };

      # External monitor 1 (center): MSI MAG 341CQP QD-OLED (34" ultrawide)
      # 3440x1440 @ 59.973Hz, horizontal orientation
      "Microstep MAG 341C OLED 0x01010101" = {
        mode = {
          width = 3440;
          height = 1440;
          refresh = 59.973;
        };
        scale = 1.0;
        position = {
          x = msiPositionX;
          y = 0;
        };
      };

      # External monitor 2 (right): Dell U2725QE (27" 4K)
      # 3840x2160 @ 120Hz, portrait orientation (90°)
      # NOTE: Per-output layout (default-column-width) is not yet exposed by
      # niri-flake settings module. If needed, set it via niri IPC or wait for
      # upstream support. Do NOT set programs.niri.config — it completely
      # overrides everything generated from programs.niri.settings.
      "Dell Inc. DELL U2725QE G3L0G84" = {
        mode = {
          width = 3840;
          height = 2160;
          refresh = 120.0;
        };
        scale = 1.5;
        transform.rotation = 90;
        position = {
          x = dellPositionX;
          y = 0;
        };
      };
    };

    # ============================================================================
    # Layer Rules
    # ============================================================================
    layer-rules = [
      {
        matches = [ { namespace = "^wallpaper$"; } ];
        place-within-backdrop = true;
      }
      {
        matches = [ { namespace = "^launcher"; } ];
        shadow = {
          enable = true;
          softness = 40;
          spread = 5;
          offset = {
            x = 0;
            y = 5;
          };
          draw-behind-window = true;
          color = "#00000050";
        };
      }
    ];

    # ============================================================================
    # Window Rules
    # ============================================================================
    window-rules = [
      # Calculator apps
      {
        matches = [ { app-id = "qalculate-gtk"; } ];
        open-maximized = true;
      }
      {
        matches = [ { app-id = "calcure"; } ];
        open-maximized = true;
      }

      # Television launcher
      {
        matches = [ { app-id = "television-launcher"; } ];
        default-column-width = { proportion = 0.8; };
        open-floating = true;
        default-window-height = { fixed = 700; };
        focus-ring = {
          enable = true;
          width = 1;
          active = {
            gradient = {
              from = "#E46876";
              to = "#c4746e";
              angle = 45;
              relative-to = "workspace-view";
            };
          };
          inactive = {
            gradient = {
              from = "#505050";
              to = "#808080";
              angle = 45;
              relative-to = "workspace-view";
            };
          };
        };
        shadow = {
          enable = true;
          softness = 40;
          spread = 5;
          offset = {
            x = 0;
            y = 5;
          };
          draw-behind-window = true;
          color = "#00000050";
        };
      }
      {
        matches = [ { title = "Television Picker"; } ];
        default-column-width = { proportion = 0.8; };
        open-floating = true;
        default-window-height = { fixed = 700; };
        focus-ring = {
          enable = true;
          width = 1;
          active = {
            gradient = {
              from = "#E46876";
              to = "#c4746e";
              angle = 45;
              relative-to = "workspace-view";
            };
          };
          inactive = {
            gradient = {
              from = "#505050";
              to = "#808080";
              angle = 45;
              relative-to = "workspace-view";
            };
          };
        };
        shadow = {
          enable = true;
          softness = 40;
          spread = 5;
          offset = {
            x = 0;
            y = 5;
          };
          draw-behind-window = true;
          color = "#00000050";
        };
      }

      # Global transparency
      {
        matches = [ { is-active = true; } ];
        opacity = 0.98;
      }
      {
        matches = [ { is-active = false; } ];
        opacity = 0.98;
      }

      # Wezterm CSD handling
      {
        matches = [ { app-id = "^org\\.wezfurlong\\.wezterm$"; } ];
      }

      # Firefox Picture-in-Picture
      {
        matches = [
          {
            app-id = "firefox$";
            title = "^Picture-in-Picture$";
          }
        ];
        open-floating = true;
      }
    ];

    # ============================================================================
    # General Settings
    # ============================================================================
    hotkey-overlay.skip-at-startup = true;
    prefer-no-csd = true;

    cursor = {
      size = 24;
      hide-after-inactive-ms = 2000;
    };

    # ============================================================================
    # Gestures
    # ============================================================================
    gestures = {
      dnd-edge-view-scroll = {
        trigger-width = 30;
        delay-ms = 100;
        max-speed = 1500;
      };
      dnd-edge-workspace-switch = {
        trigger-height = 50;
        delay-ms = 100;
        max-speed = 1500;
      };
      hot-corners.enable = false;
    };

    # ============================================================================
    # Overview
    # ============================================================================
    overview = {
      zoom = 0.6;
      workspace-shadow.enable = false;
    };

    # ============================================================================
    # Layout
    # ============================================================================
    layout = {
      shadow = {
        softness = 10;
        spread = 5;
        offset = {
          x = 0;
          y = 5;
        };
        draw-behind-window = false;
        color = "#090D1270";
        inactive-color = "#00000054";
      };

      background-color = "transparent";
      gaps = 12;
      struts = {
        left = 0;
        right = 0;
        top = 0;
        bottom = 0;
      };
      center-focused-column = "never";

      preset-column-widths = [
        { proportion = 0.33333; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
        { proportion = 1.0; }
      ];

      default-column-width = { proportion = 0.5; };

      preset-window-heights = [
        { proportion = 0.33333; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
        { proportion = 1.0; }
        { fixed = 720; }
      ];

      focus-ring = {
        enable = false;
        width = 1;
        active = {
          color = "rgb(255 200 127)";
        };
        inactive = {
          color = "rgb(80 80 80)";
        };
      };

      border = {
        enable = false;
        width = 1;
        active = {
          gradient = {
            from = "#090E13";
            to = "#C14043";
            angle = 45;
            relative-to = "workspace-view";
          };
        };
        inactive = {
          color = "#090D12";
        };
      };

      tab-indicator = {
        place-within-column = true;
        gap = 5;
        width = 4;
        length = { total-proportion = 1.0; };
        position = "left";
        gaps-between-tabs = 2;
        corner-radius = 0;
        active = {
          gradient = {
            from = "#c4b28a";
            to = "#c4746e";
            angle = 45;
          };
        };
        inactive = {
          gradient = {
            from = "#0d0c0c";
            to = "#808080";
            angle = 45;
            relative-to = "workspace-view";
          };
        };
        urgent = {
          gradient = {
            from = "#E46876";
            to = "#c4746e";
            angle = 45;
          };
        };
      };
    };

    # ============================================================================
    # Startup Programs
    # ============================================================================
    spawn-at-startup = [
      { command = [ "xwayland-satellite" ]; }
      { command = [ "sh" "-c" "~/.local/bin/fuzzel-polkit.sh" ]; }
    ];

    # ============================================================================
    # Animations
    # ============================================================================
    animations = {
      slowdown = 0.8;

      window-open.kind.easing = {
        duration-ms = 150;
        curve = "ease-out-expo";
      };

      window-close.kind.easing = {
        duration-ms = 150;
        curve = "ease-out-quad";
      };

      horizontal-view-movement.kind.spring = {
        damping-ratio = 1.0;
        stiffness = 800;
        epsilon = 0.0001;
      };

      window-movement.kind.spring = {
        damping-ratio = 1.0;
        stiffness = 800;
        epsilon = 0.0001;
      };

      window-resize.kind.spring = {
        damping-ratio = 1.0;
        stiffness = 800;
        epsilon = 0.0001;
      };

      config-notification-open-close.kind.spring = {
        damping-ratio = 0.6;
        stiffness = 1000;
        epsilon = 0.001;
      };

      screenshot-ui-open.kind.easing = {
        duration-ms = 200;
        curve = "ease-out-quad";
      };

      overview-open-close.kind.spring = {
        damping-ratio = 1.0;
        stiffness = 800;
        epsilon = 0.0001;
      };
    };

    # ============================================================================
    # Screenshot
    # ============================================================================
    screenshot-path = "~/pictures/screenshots/screenshot_%Y-%m-%d_%H-%M-%S.png";

    # ============================================================================
    # Keybindings
    # ============================================================================
    binds = {
      # System & Core Controls
      "Mod+Escape" = {
        hotkey-overlay.title = "Lock Screen";
        action.spawn = "hyprlock";
      };

      # Help / cheatsheet.
      #   Mod+F1       -> searchable keybind menu, generated from this config.
      #   Mod+ccedilla -> the full plain-text list (~/.config/niri/shortcuts.txt).
      # Mod+F1 works with ANY keyboard layout, so it is the one to remember.
      "Mod+F1" = {
        hotkey-overlay.title = "Keybind Cheatsheet";
        action.spawn-sh = cheatsheetMenu;
      };
      "Mod+ccedilla" = {
        hotkey-overlay.title = "Keybind Cheatsheet (plain text)";
        action.spawn-sh = cheatsheetText;
      };

      # Focus Navigation
      "Mod+Left" = {
        hotkey-overlay.title = "Focus Column Left";
        action.focus-column-left = [ ];
      };
      "Mod+Right" = {
        hotkey-overlay.title = "Focus Column Right";
        action.focus-column-right = [ ];
      };
      "Mod+Up" = {
        hotkey-overlay.title = "Focus Window Up";
        action.focus-window-up = [ ];
      };
      "Mod+Down" = {
        hotkey-overlay.title = "Focus Window Down";
        action.focus-window-down = [ ];
      };
      "Mod+H" = {
        hotkey-overlay.title = "Focus Column Left";
        action.focus-column-left = [ ];
      };
      "Mod+L" = {
        hotkey-overlay.title = "Focus Column Right";
        action.focus-column-right = [ ];
      };
      "Mod+K" = {
        hotkey-overlay.title = "Focus Window Up";
        action.focus-window-up = [ ];
      };
      "Mod+J" = {
        hotkey-overlay.title = "Focus Window Down";
        action.focus-window-down = [ ];
      };
      "Mod+Tab" = {
        hotkey-overlay.title = "Focus Previous Workspace";
        action.focus-workspace-previous = [ ];
      };
      "Alt+Tab" = {
        hotkey-overlay.title = "Focus Previous Window";
        action.focus-window-previous = [ ];
      };

      # Window & Column Manipulation
      "Mod+C" = {
        hotkey-overlay.title = "Close Focused Window";
        action.close-window = [ ];
      };
      "Mod+Ctrl+C" = {
        hotkey-overlay.title = "Force Kill Focused Process";
        action.spawn-sh = "$USERBIN_UTILS/utils-kill.sh";
      };
      "Mod+Ctrl+O" = {
        hotkey-overlay.title = "Toggle Opacity Focused Window";
        action.spawn-sh = "$USERBIN_UTILS/utils-opacity.sh";
      };
      "Mod+V" = {
        hotkey-overlay.title = "Toggle Window Floating";
        action.toggle-window-floating = [ ];
      };
      "Mod+Shift+V" = {
        hotkey-overlay.title = "Switch Focus Floating/Tiling";
        action.switch-focus-between-floating-and-tiling = [ ];
      };
      "Mod+Comma" = {
        hotkey-overlay.title = "Consume or Expell Window Left";
        action.consume-or-expel-window-left = [ ];
      };
      "Mod+Period" = {
        hotkey-overlay.title = "Consume or Expell Window Right";
        action.consume-or-expel-window-right = [ ];
      };

      # Move Column
      "Mod+Ctrl+Left" = {
        hotkey-overlay.title = "Move Column Left";
        action.move-column-left = [ ];
      };
      "Mod+Ctrl+Right" = {
        hotkey-overlay.title = "Move Column Right";
        action.move-column-right = [ ];
      };
      "Mod+Ctrl+Down" = {
        hotkey-overlay.title = "Move Window Down";
        action.move-column-to-workspace-down = [ ];
      };
      "Mod+Ctrl+Up" = {
        hotkey-overlay.title = "Move Window Up";
        action.move-column-to-workspace-up = [ ];
      };
      "Mod+Ctrl+H" = {
        hotkey-overlay.title = "Move Column Left";
        action.move-column-left = [ ];
      };
      "Mod+Ctrl+L" = {
        hotkey-overlay.title = "Move Column Right";
        action.move-column-right = [ ];
      };
      "Mod+Ctrl+J" = {
        hotkey-overlay.title = "Move Window Down";
        action.move-column-to-workspace-down = [ ];
      };
      "Mod+Ctrl+K" = {
        hotkey-overlay.title = "Move Window Up";
        action.move-column-to-workspace-up = [ ];
      };

      # Move Window
      "Mod+Ctrl+S" = {
        hotkey-overlay.title = "Move Window Up";
        action.move-window-up-or-to-workspace-up = [ ];
      };
      "Mod+Ctrl+A" = {
        hotkey-overlay.title = "Move Window Down";
        action.move-window-down-or-to-workspace-down = [ ];
      };

      # Maximize & Resize
      "Mod+F" = {
        hotkey-overlay.title = "Maximize Column";
        action.maximize-column = [ ];
      };
      "Mod+Shift+F" = {
        hotkey-overlay.title = "Fullscreen Window";
        action.fullscreen-window = [ ];
      };
      "Mod+Z" = {
        hotkey-overlay.title = "Toggle Column Tabbed Display";
        action.toggle-column-tabbed-display = [ ];
      };
      "Mod+Shift+C" = {
        hotkey-overlay.title = "Center Column";
        action.center-column = [ ];
      };
      "Mod+R" = {
        hotkey-overlay.title = "Switch Preset Column Width";
        action.switch-preset-column-width = [ ];
      };
      "Mod+Shift+R" = {
        hotkey-overlay.title = "Switch Preset Window Height";
        action.switch-preset-window-height = [ ];
      };
      "Mod+Ctrl+R" = {
        hotkey-overlay.title = "Reset Window Height";
        action.reset-window-height = [ ];
      };
      "Mod+Minus" = {
        hotkey-overlay.title = "Decrease Column Width";
        action.set-column-width = "-10%";
      };
      "Mod+Equal" = {
        hotkey-overlay.title = "Increase Column Width";
        action.set-column-width = "+10%";
      };
      "Mod+Shift+Minus" = {
        hotkey-overlay.title = "Decrease Window Height";
        action.set-window-height = "-10%";
      };
      "Mod+Shift+Equal" = {
        hotkey-overlay.title = "Increase Window Height";
        action.set-window-height = "+10%";
      };

      # Monitor Navigation
      "Mod+Alt+Left" = {
        hotkey-overlay.title = "Focus Monitor Left";
        action.focus-monitor-left = [ ];
      };
      "Mod+Alt+Right" = {
        hotkey-overlay.title = "Focus Monitor Right";
        action.focus-monitor-right = [ ];
      };

      # Workspace Navigation (Dynamic)
      "Mod+Alt+Up" = {
        hotkey-overlay.title = "Move Workspace Up";
        action.move-workspace-up = [ ];
      };
      "Mod+Alt+Down" = {
        hotkey-overlay.title = "Move Workspace Down";
        action.move-workspace-down = [ ];
      };
      "Mod+Shift+Up" = {
        hotkey-overlay.title = "Focus Workspace Up";
        action.focus-workspace-up = [ ];
      };
      "Mod+Shift+Down" = {
        hotkey-overlay.title = "Focus Workspace Down";
        action.focus-workspace-down = [ ];
      };

      # Workspace Navigation (Numeric)
      "Mod+1" = {
        hotkey-overlay.title = "Focus Workspace 1";
        action.focus-workspace = 1;
      };
      "Mod+2" = {
        hotkey-overlay.title = "Focus Workspace 2";
        action.focus-workspace = 2;
      };
      "Mod+3" = {
        hotkey-overlay.title = "Focus Workspace 3";
        action.focus-workspace = 3;
      };
      "Mod+4" = {
        hotkey-overlay.title = "Focus Workspace 4";
        action.focus-workspace = 4;
      };
      "Mod+5" = {
        hotkey-overlay.title = "Focus Workspace 5";
        action.focus-workspace = 5;
      };
      "Mod+6" = {
        hotkey-overlay.title = "Focus Workspace 6";
        action.focus-workspace = 6;
      };
      "Mod+7" = {
        hotkey-overlay.title = "Focus Workspace 7";
        action.focus-workspace = 7;
      };
      "Mod+8" = {
        hotkey-overlay.title = "Focus Workspace 8";
        action.focus-workspace = 8;
      };
      "Mod+9" = {
        hotkey-overlay.title = "Focus Workspace 9";
        action.focus-workspace = 9;
      };
      "Mod+0" = {
        hotkey-overlay.title = "Focus Workspace 10";
        action.focus-workspace = 10;
      };

      # Move to Workspace (Numeric)
      "Mod+Shift+1" = {
        hotkey-overlay.title = "Move Column to Workspace 1";
        action.move-column-to-workspace = 1;
      };
      "Mod+Shift+2" = {
        hotkey-overlay.title = "Move Column to Workspace 2";
        action.move-column-to-workspace = 2;
      };
      "Mod+Shift+3" = {
        hotkey-overlay.title = "Move Column to Workspace 3";
        action.move-column-to-workspace = 3;
      };
      "Mod+Shift+4" = {
        hotkey-overlay.title = "Move Column to Workspace 4";
        action.move-column-to-workspace = 4;
      };
      "Mod+Shift+5" = {
        hotkey-overlay.title = "Move Column to Workspace 5";
        action.move-column-to-workspace = 5;
      };
      "Mod+Shift+6" = {
        hotkey-overlay.title = "Move Column to Workspace 6";
        action.move-column-to-workspace = 6;
      };
      "Mod+Shift+7" = {
        hotkey-overlay.title = "Move Column to Workspace 7";
        action.move-column-to-workspace = 7;
      };
      "Mod+Shift+8" = {
        hotkey-overlay.title = "Move Column to Workspace 8";
        action.move-column-to-workspace = 8;
      };
      "Mod+Shift+9" = {
        hotkey-overlay.title = "Move Column to Workspace 9";
        action.move-column-to-workspace = 9;
      };
      "Mod+Shift+0" = {
        hotkey-overlay.title = "Move Column to Workspace 10";
        action.move-column-to-workspace = 10;
      };

      # Application Launchers (Primary)
      # App menu (fuzzel): exactly the same thing as clicking the "rhodium"
      # button on the bar. Mod+A is the launcher key in the original hyprland
      # config; the screenshot annotate that used to live here moved to
      # Mod+Alt+A (see Screenshots below).
      "Mod+A" = {
        hotkey-overlay.title = "Launch App Menu [Fuzzel]";
        action.spawn = "fuzzel";
      };
      "Mod+W" = {
        hotkey-overlay.title = "Launch Terminal [Kitty]";
        action.spawn = "kitty";
      };
      "Mod+B" = {
        hotkey-overlay.title = "Launch Browser [Firefox]";
        # Firefox's default profile. To always use a named profile, set
        # `profiles.firefox.personal` in data/users/preferences/apps.nix (the
        # same setting the browser/links use) and spawn it with the `-P` flag.
        action.spawn = "firefox";
      };
      "Mod+D" = {
        hotkey-overlay.title = "Launch File Manager [Yazi]";
        action.spawn = [ "kitty" "-e" "yazi" ];
      };
      "Mod+E" = {
        hotkey-overlay.title = "Launch Editor [Nvim]";
        action.spawn = [ "kitty" "-e" "nvim" ];
      };
      "Mod+Q" = {
        hotkey-overlay.title = "Toggle Calculator [CLI]";
        action.spawn-sh = "$USERBIN_LAUNCHERS/launchers-qalc.sh";
      };

      # Application Launchers (Secondary - Shift)
      "Mod+Shift+W" = {
        hotkey-overlay.title = "Launch Terminal [Ghostty]";
        action.spawn = "ghostty";
      };
      "Mod+Shift+B" = {
        hotkey-overlay.title = "Launch Browser [Brave]";
        action.spawn = "brave";
      };
      "Mod+Shift+D" = {
        hotkey-overlay.title = "Launch File Manager [Thunar]";
        action.spawn = "thunar";
      };
      "Mod+Shift+E" = {
        hotkey-overlay.title = "Launch Editor [Doom Emacs]";
        action.spawn = [ "emacsclient" "-c" ];
      };
      "Mod+Shift+Q" = {
        hotkey-overlay.title = "Toggle Calculator [GUI]";
        action.spawn-sh = "$USERBIN_LAUNCHERS/launchers-qalculate.sh";
      };

      # Application Launchers (Tertiary - Ctrl)
      "Mod+Ctrl+Q" = {
        hotkey-overlay.title = "Toggle Calendar";
        action.spawn-sh = "$USERBIN_LAUNCHERS/launchers-calcure.sh";
      };
      "Mod+Ctrl+E" = {
        hotkey-overlay.title = "Launch Editor [Zed Editor]";
        action.spawn = "zeditor";
      };

      # Screenshots
      "Mod+S" = {
        hotkey-overlay.title = "Screenshot Screen";
        action.screenshot-screen = [ ];
      };
      "Print" = {
        hotkey-overlay.title = "Screenshot Screen";
        action.screenshot-screen = [ ];
      };
      "Mod+Shift+S" = {
        hotkey-overlay.title = "Screenshot Interactive";
        action.screenshot = [ ];
      };
      "Shift+Print" = {
        hotkey-overlay.title = "Screenshot Interactive";
        action.screenshot = [ ];
      };
      "Mod+Alt+S" = {
        hotkey-overlay.title = "Screenshot Window";
        action.screenshot-window = [ ];
      };
      "Ctrl+Print" = {
        hotkey-overlay.title = "Screenshot Window";
        action.screenshot-window = [ ];
      };
      # Annotate lives on Mod+Alt+A now: Mod+A is the app menu (see launchers),
      # next to Mod+Alt+S (screenshot window). Alt+Print keeps working too.
      "Mod+Alt+A" = {
        hotkey-overlay.title = "Screenshot Annotate";
        action.spawn-sh = "$USERBIN_UTILS/utils-screenshot-annotate.sh";
      };
      "Alt+Print" = {
        hotkey-overlay.title = "Screenshot Interactive [A]nnotate";
        action.spawn-sh = "$USERBIN_UTILS/utils-screenshot-annotate.sh";
      };
      "Mod+Shift+A" = {
        hotkey-overlay.title = "Screenshot Interactive OCR";
        action.spawn-sh = "$USERBIN_UTILS/utils-ocr.sh";
      };

      # Mouse & Trackpad Scroll Bindings
      "Mod+WheelScrollDown" = {
        hotkey-overlay.title = "Focus Workspace Down (Scroll)";
        action.focus-workspace-down = [ ];
        cooldown-ms = 50;
      };
      "Mod+WheelScrollUp" = {
        hotkey-overlay.title = "Focus Workspace Up (Scroll)";
        action.focus-workspace-up = [ ];
        cooldown-ms = 50;
      };
      "Mod+WheelScrollRight" = {
        hotkey-overlay.title = "Focus Column Right (Scroll)";
        action.focus-column-right = [ ];
        cooldown-ms = 100;
      };
      "Mod+WheelScrollLeft" = {
        hotkey-overlay.title = "Focus Column Left (Scroll)";
        action.focus-column-left = [ ];
        cooldown-ms = 100;
      };
      "Mod+TouchpadScrollUp" = {
        hotkey-overlay.title = "Increase Volume (Touchpad)";
        action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02+" ];
      };
      "Mod+TouchpadScrollDown" = {
        hotkey-overlay.title = "Decrease Volume (Touchpad)";
        action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02-" ];
      };

      # Multimedia & Hardware Controls
      "XF86AudioRaiseVolume" = {
        hotkey-overlay.title = "Increase Volume";
        action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+" ];
        allow-when-locked = true;
      };
      "XF86AudioLowerVolume" = {
        hotkey-overlay.title = "Decrease Volume";
        action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-" ];
        allow-when-locked = true;
      };
      "XF86AudioMute" = {
        hotkey-overlay.title = "Toggle Mute";
        action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
        allow-when-locked = true;
      };
      "XF86AudioMicMute" = {
        hotkey-overlay.title = "Toggle Mute";
        action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ];
        allow-when-locked = true;
      };
      "XF86MonBrightnessUp" = {
        hotkey-overlay.title = "Increase Brightness";
        action.spawn = [ "brightnessctl" "set" "+5%" ];
        allow-when-locked = true;
      };
      "XF86MonBrightnessDown" = {
        hotkey-overlay.title = "Decrease Brightness";
        action.spawn = [ "brightnessctl" "set" "5%-" ];
        allow-when-locked = true;
      };
      "XF86AudioPlay" = {
        hotkey-overlay.title = "Play/Pause Media";
        action.spawn = [ "playerctl" "play-pause" ];
        allow-when-locked = true;
      };
      "XF86AudioNext" = {
        hotkey-overlay.title = "Next Media Track";
        action.spawn = [ "playerctl" "next" ];
        allow-when-locked = true;
      };
      "XF86AudioPrev" = {
        hotkey-overlay.title = "Previous Media Track";
        action.spawn = [ "playerctl" "previous" ];
        allow-when-locked = true;
      };

      # Overview
      "Mod+X" = {
        hotkey-overlay.title = "Toggle Overview";
        action.toggle-overview = [ ];
        repeat = false;
      };
    };
  };

  # ----------------------------------------------------------------------------
  # Keybind cheatsheet
  # ----------------------------------------------------------------------------
  # Plain-text list of every keybind. Shown with Mod + F1 (see binds above),
  # and always available at ~/.config/niri/shortcuts.txt.
  xdg.configFile."niri/shortcuts.txt".source = ./shortcuts.txt;
}
