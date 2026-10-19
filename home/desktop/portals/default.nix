{ pkgs, config, ... }:
let
  c = config.theme.colors;

  # rhodium red: the accent niri paints on the focused window border.
  accent = "#c14043";

  # GTK apps get the rice's palette on top of the Adwaita-dark base theme.
  # libadwaita/GTK4 use these same @define-color names, so both versions
  # follow along (tonal grey surfaces are derived from theme_bg_color).
  gtkCss = ''
    @define-color theme_bg_color ${c.base00};
    @define-color theme_base_color ${c.base01};
    @define-color theme_fg_color ${c.base05};
    @define-color theme_text_color ${c.base05};
    @define-color theme_selected_bg_color ${accent};
    @define-color theme_selected_fg_color ${c.base00};
    @define-color theme_unfocused_bg_color ${c.base00};
    @define-color theme_unfocused_fg_color ${c.base03};
    @define-color borders ${c.base02};
    @define-color accent_color ${accent};
    @define-color accent_bg_color ${accent};
    @define-color accent_fg_color ${c.base00};
    @define-color window_bg_color ${c.base00};
    @define-color window_fg_color ${c.base05};
    @define-color view_bg_color ${c.base00};
    @define-color view_fg_color ${c.base05};
    @define-color headerbar_bg_color ${c.base00};
    @define-color headerbar_fg_color ${c.base05};
    @define-color popover_bg_color ${c.base01};
    @define-color popover_fg_color ${c.base05};
    @define-color card_bg_color ${c.base01};
    @define-color card_fg_color ${c.base05};
  '';
in
{
  home.packages = with pkgs; [
    # GTK theme requirements
    sassc
    gtk-engine-murrine
    gnome-themes-extra
    adwaita-icon-theme

    # Qt themes
    (catppuccin-kvantum.override {
      variant = "mocha";
      # Was "mauve" upstream; the rice's accent is red.
      accent = "red";
    })
  ];

  # GTK
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "phinger-cursors-dark";
      package = pkgs.phinger-cursors;
      size = 24;
    };

    # rhodium palette; see home/assets/themes/chiaroscuro.nix.
    gtk3.extraCss = gtkCss;
    gtk4.extraCss = gtkCss;
  };

  # Qt
  qt = {
    enable = true;
    platformTheme.name = "gtk"; # Follow GTK theme
    style = {
      name = "kvantum";
      package = pkgs.libsForQt5.qtstyleplugin-kvantum;
    };
  };
}
