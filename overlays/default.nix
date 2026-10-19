{ inputs }:
{
  fonts = import ./fonts.nix { inherit inputs; };
  opencode = import ./opencode.nix { inherit inputs; };
}
