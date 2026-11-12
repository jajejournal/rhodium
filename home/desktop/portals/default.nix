{
  pkgs,
  config,
  lib,
  ...
}:
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
    @define-color headerbar_backdrop_color ${c.base00};
    @define-color popover_bg_color ${c.base01};
    @define-color popover_fg_color ${c.base05};
    @define-color card_bg_color ${c.base01};
    @define-color card_fg_color ${c.base05};
    @define-color sidebar_bg_color ${c.base01};
    @define-color sidebar_fg_color ${c.base05};
    @define-color secondary_sidebar_bg_color ${c.base00};
    @define-color dialog_bg_color ${c.base01};
    @define-color dialog_fg_color ${c.base05};
    @define-color shade_color ${c.base02};
  '';

  # GLib only looks for gschemas.compiled in specific data directories. NixOS
  # nests every package's schemas under share/gsettings-schemas/<name>, which
  # GLib does not scan, so gsettings (and the Qt GTK platform theme) sees no
  # schemas at all. Dropping a merged gschemas.compiled in XDG_DATA_HOME adds
  # them without overriding the per-app schema dirs.
  gsettingsSchemas =
    pkgs.runCommandLocal "rhodium-gsettings-schemas"
      {
        nativeBuildInputs = [ pkgs.glib ];
      }
      ''
        mkdir -p $out
        cp -r ${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas/. $out/
        rm -f $out/gschemas.compiled
        cp -r ${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas/. $out/
        chmod -R u+w $out
        rm -f $out/gschemas.compiled
        glib-compile-schemas $out
      '';

  kvantumTheme = import ../../assets/themes/kvantum-chiaroscuro.nix { inherit pkgs lib; };
in
{
  home.packages = with pkgs; [
    # GTK theme requirements
    sassc
    gtk-engine-murrine
    gnome-themes-extra
    adwaita-icon-theme

    # Qt themes
    kvantumTheme
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
  ];

  # The Qt GTK platform theme reads GTK settings through GSettings. Install
  # the merged schema database into XDG_DATA_HOME so plain `gsettings` works
  # too, without shadowing application-specific schema directories.
  xdg.dataFile."glib-2.0/schemas/gschemas.compiled".source = "${gsettingsSchemas}/gschemas.compiled";

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

    # libadwaita decides between light/dark before it looks at the theme name;
    # without this, GTK4 apps (and Kirigami under the GTK platform theme) fall
    # back to the light palette.
    colorScheme = "dark";

    # rhodium palette; see home/assets/themes/chiaroscuro.nix.
    gtk3.extraCss = gtkCss;
    gtk4.extraCss = gtkCss;
  };

  # Writes org/gnome/desktop/interface color-scheme=prefer-dark and friends.
  dconf.enable = true;

  # Qt
  qt = {
    enable = true;
    platformTheme.name = "gtk"; # Follow GTK theme
    style = {
      name = "kvantum";
      package = [
        pkgs.libsForQt5.qtstyleplugin-kvantum
        pkgs.qt6Packages.qtstyleplugin-kvantum
      ];
    };
  };

  # Select the Chiaroscuro Kvantum skin. Kept as a file (not an env var) so
  # kvantum-settings/apps agree and the choice survives reboots.
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Chiaroscuro
  '';
}
