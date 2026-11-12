{ pkgs, theme, ... }:
{
  programs.zathura = {
    enable = true;

    options = {
      # --- Performance ---
      render-loading = true;
      render-loading-bg = theme.colors.base00;
      render-loading-fg = theme.colors.base05;
      page-cache-size = 50; # Cache more pages for faster navigation
      pages-per-row = 1;
      scroll-page-aware = true;
      scroll-full-overlap = "0.01";
      scroll-step = 100;

      # --- UI & Appearance ---
      font = "${theme.fonts.mono or "JetBrainsMono Nerd Font"} 11";
      statusbar-home-tilde = true;
      window-title-home-tilde = true;
      window-title-basename = true;
      guioptions = "shv"; # Show statusbar, horizontal/vertical scrollbars

      # --- Search ---
      incremental-search = true;
      nohlsearch = false; # Keep search highlights visible

      # --- Clipboard ---
      selection-clipboard = "clipboard"; # Use system clipboard for selections
      selection-notification = true;

      # --- Zoom ---
      zoom-min = 10;
      zoom-max = 1000;
      zoom-step = 10;
      adjust-open = "best-fit";

      # --- Colors (Chiaroscuro) ---
      default-bg = theme.colors.base00;
      default-fg = theme.colors.base05;
      statusbar-bg = theme.colors.base01;
      statusbar-fg = theme.colors.base05;
      inputbar-bg = theme.colors.base01;
      inputbar-fg = theme.colors.base05;
      notification-bg = theme.colors.base01;
      notification-fg = theme.colors.base0B;
      notification-error-bg = theme.colors.base01;
      notification-error-fg = theme.colors.base08;
      notification-warning-bg = theme.colors.base01;
      notification-warning-fg = theme.colors.base0A;
      highlight-color = theme.colors.base09;
      highlight-active-color = theme.colors.base0B;
      completion-bg = theme.colors.base01;
      completion-fg = theme.colors.base05;
      completion-highlight-bg = theme.colors.base0D;
      completion-highlight-fg = theme.colors.base00;
      completion-group-bg = theme.colors.base01;
      completion-group-fg = theme.colors.base0D;
      index-bg = theme.colors.base00;
      index-fg = theme.colors.base05;
      index-active-bg = theme.colors.base0D;
      index-active-fg = theme.colors.base00;

      # --- Recolor (dark mode for PDFs) ---
      recolor = true; # Don't recolor by default
      recolor-keephue = true;
      recolor-darkcolor = theme.colors.base05;
      recolor-lightcolor = theme.colors.base00;
      recolor-reverse-video = true;
    };

    mappings = {
      # Navigation
      "<C-d>" = "scroll half-down";
      "<C-u>" = "scroll half-up";
      "D" = "toggle_page_mode";
      "r" = "rotate rotate-cw";
      "R" = "rotate rotate-ccw";
      "K" = "zoom in";
      "J" = "zoom out";
      "i" = "recolor"; # Toggle dark mode
      "<C-r>" = "reload";
      "p" = "print";
      "b" = "toggle_statusbar";
      "<C-c>" = "abort";

      # Bookmarks
      "m" = "mark_evaluate";
      "'" = "mark_evaluate";

      # Index (table of contents)
      "<Tab>" = "toggle_index";
    };

    extraConfig = ''
      # Additional settings
      set database sqlite
      set sandbox normal
      set page-padding 2
      set show-recent 20
      set first-page-column 1
    '';
  };
}
