{ ... }:
final: prev: {
  # ───────────────────────────────────────────────────────────────────────────
  # rhodium-fonts
  # ───────────────────────────────────────────────────────────────────────────
  # Upstream Rhodium built this from a PRIVATE flake input (`iridium-rh`) that
  # shipped Berkeley Mono (paid, commercial) + Server Mono. That made the repo
  # unbuildable for anyone without access to that private repo.
  #
  # We replace it with a FREE (SIL OFL) Nerd Font so the system builds anywhere.
  # The font family name used across the configs is "JetBrainsMono Nerd Font".
  #
  # Want a different one? Any `pkgs.nerd-fonts.*` attr works, e.g.:
  #   prev.nerd-fonts.maple-mono
  #   prev.nerd-fonts.iosevka
  #   prev.nerd-fonts.commit-mono
  # Remember to also update the font-family strings (search "JetBrainsMono Nerd Font").
  # ───────────────────────────────────────────────────────────────────────────
  rhodium-fonts = prev.nerd-fonts.jetbrains-mono;
}
