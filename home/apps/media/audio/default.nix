{ pkgs, ... }:
{
  imports = [
    ./csound.nix
    ./ncmpc.nix
    ./puredata.nix
    ./rmpc.nix
    ./roon.nix
    ./sonicpi.nix
    ./supercollider.nix
    ./tidal.nix
    ./tidalcycles.nix
    ./vcv-rack.nix
  ];

  home.packages = with pkgs; [
    # audacious
    # audacity
    clementine
    easyeffects # Equalizer for PipeWire
    helvum # GTK patchbay for PipeWire
    playerctl # CLI util & lib for controlling audio
    cavalier # Terminal audio visualizer

    # --- TUI Music Players ---
    termusic # Feature-rich music player in Rust
    cmus # Small, fast console music player

    # NOTE: Roon is opt-in (rh.apps.media.audio.roon) - see ./roon.nix.
  ];
}
