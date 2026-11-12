# Kvantum theme for the rice.
#
# KvDarkRed already ships the widget geometry and the red accent, so we only
# recolour its greys to the Chiaroscuro ramp (base00..base03) and snap the
# accent to the rhodium red. Recolouring the SVG + kvconfig keeps every widget
# state (hover, pressed, flat, ...) that the upstream theme already covers.
{ pkgs, lib }:
let
  base = "${pkgs.qt6Packages.qtstyleplugin-kvantum}/share/Kvantum/KvDarkRed";

  # Old hex -> Chiaroscuro token. Matching is case-insensitive because the
  # kvconfig uses uppercase (#3D3D3E) while the SVG uses lowercase.
  recolor = {
    # Surfaces: window / button / base
    "3d3d3e" = "0a0e13"; # base01
    "2e2e2e" = "0a0e13";
    "383838" = "10161d"; # base02
    "3c3c3c" = "10161d";
    "323232" = "10161d";
    "373737" = "10161d";
    "282828" = "0a0e13";
    "242424" = "0a0e13";
    "232323" = "0a0e13";

    # Deep edges
    "1e1e1e" = "000000"; # base00
    "191919" = "000000";
    "141414" = "000000";

    # Borders / separators
    "646464" = "445564"; # base03
    "555555" = "2c3a47";
    "5a5a5a" = "2c3a47";
    "4d4d4d" = "2c3a47";
    "585858" = "2c3a47";
    "616161" = "2c3a47";

    # Disabled / secondary text
    "787878" = "5e5e5f"; # base04
    "808080" = "5e5e5f";
    "828282" = "5e5e5f";
    "a0a0a0" = "5e5e5f";

    # Text
    "bebebe" = "bdcbd8"; # base05
    "c8c8c8" = "bdcbd8";
    "d2d2d2" = "e3e9ef"; # base06

    # Accent
    "870f11" = "c14043"; # rhodium red
    "8c1011" = "c14043";
    "730d0e" = "a33437"; # pressed / inactive highlight

    # Links
    "2eb8e6" = "4a7fff"; # base0D
    "ff6666" = "e57e65"; # base08
  };

  sedArgs = lib.concatStringsSep " " (
    lib.mapAttrsToList (from: to: "-e 's/${from}/${to}/gI'") recolor
  );
in
pkgs.runCommandLocal "kvantum-chiaroscuro" { } ''
  dir="$out/share/Kvantum/Chiaroscuro"
  mkdir -p "$dir"

  cp ${base}/KvDarkRed.svg "$dir/Chiaroscuro.svg"
  cp ${base}/KvDarkRed.kvconfig "$dir/Chiaroscuro.kvconfig"

  sed -i ${sedArgs} "$dir/Chiaroscuro.svg" "$dir/Chiaroscuro.kvconfig"
  sed -i 's/^comment=.*/comment=Chiaroscuro (rhodium)/' "$dir/Chiaroscuro.kvconfig"
''
