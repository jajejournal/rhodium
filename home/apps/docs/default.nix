{ pkgs, ... }:
{
  imports = [
    # ./anytype.nix
    # ./appflowy.nix
    # ./joplin.nix
    # ./logseq.nix
    # ./notion.nix
    ./obsidian.nix
    ./obsidian-theme.nix
    ./okular.nix
    # ./roam.nix
    ./standardnotes.nix
    ./zathura.nix
  ];
}
