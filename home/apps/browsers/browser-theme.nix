# Shared theming for the Firefox-family browsers (Firefox, Zen, LibreWolf), so
# their UI follows the same palette as the rest of the rice (see
# home/assets/themes/chiaroscuro.nix). Import it like:
#
#   import ./browser-theme.nix { theme = config.theme; }
#
{ theme }:
let
  c = theme.colors;

  # rhodium red: the accent niri paints on the active window border and that
  # waybar uses for alerts.
  accent = "#c14043";
in
rec {
  # ── Preferences ──────────────────────────────────────────────────────────
  # `legacySettings` applies to every Firefox-based browser; `firefoxSettings`
  # is Firefox-specific (Zen ships and manages its own theme).
  legacySettings = {
    # Allow the userChrome/userContent files below to be loaded.
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  };

  firefoxSettings = {
    # Dark browser UI and dark websites, matching the rice.
    "browser.theme.toolbar-theme" = 0;
    "browser.theme.content-theme" = 0;
    "ui.systemUsesDarkTheme" = 1;
    "layout.css.prefers-color-scheme.content-override" = 0;
    "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
    # Page colors used when a site does not specify its own.
    "browser.display.background_color.dark" = c.base00;
    "browser.display.foreground_color.dark" = c.base05;
  };

  # ── Browser UI: tabs, toolbars, menus, sidebars ──────────────────────────
  userChrome = ''
    /* rhodium — browser chrome on the rice's theme (chiaroscuro, dark). */
    :root {
      --rh-bg: ${c.base00};
      --rh-surface: ${c.base01};
      --rh-surface-hi: ${c.base02};
      --rh-fg: ${c.base05};
      --rh-dim: ${c.base03};
      --rh-accent: ${accent};

      --toolbar-bgcolor: var(--rh-bg) !important;
      --toolbar-color: var(--rh-fg) !important;
      --toolbarbutton-icon-fill: var(--rh-fg) !important;
      --toolbarbutton-hover-background: var(--rh-surface-hi) !important;
      --toolbarbutton-active-background: var(--rh-surface-hi) !important;

      --lwt-accent-color: var(--rh-bg) !important;
      --lwt-accent-color-inactive: var(--rh-bg) !important;
      --lwt-text-color: var(--rh-fg) !important;
      --lwt-toolbar-field-background-color: var(--rh-surface) !important;
      --lwt-toolbar-field-color: var(--rh-fg) !important;
      --lwt-toolbar-field-border-color: var(--rh-surface-hi) !important;
      --lwt-toolbar-field-focus: var(--rh-surface) !important;

      --tab-selected-bgcolor: var(--rh-surface) !important;
      --tab-selected-textcolor: var(--rh-fg) !important;
      --tabpanel-background-color: var(--rh-bg) !important;

      --arrowpanel-background: var(--rh-bg) !important;
      --arrowpanel-color: var(--rh-fg) !important;
      --arrowpanel-border-color: var(--rh-surface-hi) !important;
      --newtab-background-color: var(--rh-bg) !important;

      --sidebar-background-color: var(--rh-bg) !important;
      --sidebar-text-color: var(--rh-fg) !important;
      --sidebar-border-color: var(--rh-surface-hi) !important;

      --urlbar-box-bgcolor: var(--rh-surface) !important;
      --focus-outline-color: var(--rh-accent) !important;
      --link-color: var(--rh-accent) !important;
    }

    /* Red accent, like the border niri draws on the focused window. */
    #urlbar[focused="true"] > #urlbar-background {
      outline: 1px solid var(--rh-accent) !important;
    }

    .tabbrowser-tab[selected] .tab-background {
      border-bottom: 2px solid var(--rh-accent) !important;
    }
  '';

  # ── Web content: scrollbars and selection ────────────────────────────────
  userContent = ''
    /* rhodium — pages blend with the theme: dark scrollbars, red accents. */
    :root {
      scrollbar-color: ${c.base02} ${c.base00} !important;
      accent-color: ${accent} !important;
    }

    ::selection {
      background: ${accent} !important;
      color: ${c.base00} !important;
    }
  '';
}
