{
  config,
  lib,
  pkgs,
  ...
}:
let
  c = config.theme.colors;

  accent = "#c14043";
  accentHover = "#d65a5d";
  accentSurface = "#c1404324";
  accentSurfaceStrong = "#c1404338";

  css = ''

    .theme-dark {
      --background-primary: ${c.base01};
      --background-primary-alt: ${c.base02};
      --background-secondary: ${c.base00};
      --background-secondary-alt: ${c.base00};
      --background-modifier-border: ${c.base02};
      --background-modifier-border-hover: ${c.base03};
      --background-modifier-border-focus: ${accent};
      --background-modifier-form-field: ${c.base02};
      --background-modifier-form-field-highlighted: ${c.base02};
      --background-modifier-hover: ${c.base02};
      --background-modifier-active-hover: ${c.warm-surface};
      --background-modifier-selected: ${accentSurface};
      --background-modifier-success: ${c.success-surface};
      --background-modifier-error: ${c.error-surface};
      --background-modifier-error-hover: #e57e6533;
      --background-modifier-cover: rgba(0, 0, 0, 0.78);
      --background-modifier-box-shadow: rgba(0, 0, 0, 0.65);
      --background-modifier-message: ${c.base02};
      --workspace-background-translucent: rgba(10, 14, 19, 0.92);

      --text-normal: ${c.base05};
      --text-muted: ${c.base04};
      --text-faint: ${c.base03};
      --text-on-accent: ${c.base07};
      --text-on-accent-inverted: ${c.base00};
      --text-success: ${c.base0B};
      --text-warning: ${c.base0A};
      --text-error: ${c.base08};
      --text-accent: ${accent};
      --text-accent-hover: ${accentHover};
      --text-selection: ${c.selection};
      --text-highlight-bg: #d4bf9440;
      --text-highlight-bg-active: #c1404355;
      --text-normal-weight: 400;
      --text-bold-weight: 600;

      --interactive-normal: ${c.base02};
      --interactive-hover: ${c.warm-surface};
      --interactive-accent: ${accent};
      --interactive-accent-hover: ${accentHover};
      --interactive-accent-rgb: 193, 64, 67;
      --interactive-success: ${c.base0B};
      --input-background: ${c.base02};
      --input-border-color: ${c.base02};
      --slider-track-background: ${c.base02};
      --slider-thumb-background: ${accent};

      --color-base-00: ${c.base01};
      --color-base-05: ${c.base01};
      --color-base-10: ${c.base02};
      --color-base-20: ${c.base02};
      --color-base-25: ${c.base02};
      --color-base-30: ${c.base03};
      --color-base-35: ${c.base03};
      --color-base-40: ${c.base04};
      --color-base-50: ${c.base04};
      --color-base-60: ${c.base05};
      --color-base-70: ${c.base06};
      --color-base-80: ${c.base06};
      --color-base-90: ${c.base07};
      --color-base-100: ${c.base07};

      --color-red: ${c.base08};
      --color-orange: ${c.base09};
      --color-yellow: ${c.base0A};
      --color-green: ${c.base0B};
      --color-cyan: ${c.base0C};
      --color-blue: ${c.base0D};
      --color-purple: ${c.base0E};
      --color-pink: ${c.base0F};

      --color-red-rgb: 235, 164, 145;
      --color-orange-rgb: 246, 169, 79;
      --color-yellow-rgb: 212, 191, 148;
      --color-green-rgb: 53, 171, 148;
      --color-cyan-rgb: 89, 191, 170;
      --color-blue-rgb: 74, 127, 255;
      --color-purple-rgb: 90, 92, 138;
      --color-pink-rgb: 247, 89, 171;

      --color-accent: ${accent};
      --color-accent-1: ${accent};
      --color-accent-2: ${accentHover};
      --color-accent-hsl: 359, 51%, 50%;
      --accent-h: 359;
      --accent-s: 51%;
      --accent-l: 50%;

      --font-interface: "Work Sans", "Inter", system-ui, sans-serif;
      --font-text: "Work Sans", "Inter", system-ui, sans-serif;
      --font-monospace: "JetBrainsMono Nerd Font", "JetBrains Mono", monospace;
      --font-text-size: 16px;
      --font-ui-small: 13px;
      --font-ui-medium: 15px;
      --font-ui-large: 20px;
      --line-height-normal: 1.6;
      --line-height-tight: 1.3;

      --h1-size: 2em;
      --h2-size: 1.6em;
      --h3-size: 1.35em;
      --h4-size: 1.15em;
      --h5-size: 1.05em;
      --h6-size: 1em;
      --h1-color: ${c.base07};
      --h2-color: ${c.base06};
      --h3-color: ${c.base05};
      --h4-color: ${c.base05};
      --h5-color: ${c.base05};
      --h6-color: ${c.base04};
      --inline-title-color: ${c.base07};
      --inline-title-size: 2.2em;
      --inline-title-weight: 600;

      --link-color: ${accent};
      --link-color-hover: ${accentHover};
      --link-external-color: ${c.base0D};
      --link-external-color-hover: ${c.base0C};
      --link-unresolved-color: ${c.base04};
      --link-unresolved-opacity: 0.7;

      --tag-background: ${c.base02};
      --tag-background-hover: ${accentSurface};
      --tag-color: ${c.base0D};
      --tag-color-hover: ${c.base0D};
      --tag-border-color: ${c.base03};
      --tag-border-color-hover: ${accent};
      --tag-border-width: 1px;
      --tag-size: 0.85em;
      --tag-padding-x: 0.5em;
      --tag-padding-y: 0.15em;
      --tag-radius: 0px;

      --blockquote-border-color: ${accent};
      --blockquote-border-thickness: 3px;
      --blockquote-background-color: ${c.base02};
      --blockquote-color: ${c.base05};

      --code-background: ${c.base02};
      --code-normal: ${c.base05};
      --code-comment: ${c.comment};
      --code-function: ${c.base0D};
      --code-important: ${c.base08};
      --code-keyword: ${c.base0E};
      --code-operator: ${c.base0C};
      --code-property: ${c.base0A};
      --code-punctuation: ${c.base04};
      --code-string: ${c.base0B};
      --code-tag: ${c.base08};
      --code-value: ${c.base09};

      --table-border-color: ${c.base02};
      --table-border-width: 1px;
      --table-header-background: ${c.base02};
      --table-header-background-hover: ${c.warm-surface};
      --table-row-background-hover: ${c.base02};
      --table-row-alt-background: ${c.base00};
      --table-column-alt-background: transparent;

      --checkbox-color: ${accent};
      --checkbox-color-hover: ${accentHover};
      --checkbox-border-color: ${c.base03};
      --checkbox-border-color-hover: ${accent};
      --checkbox-marker-color: ${c.base07};
      --checklist-done-color: ${c.base04};

      --callout-border-width: 1px;
      --callout-border-opacity: 1;
      --callout-padding: 12px 16px;
      --callout-radius: 0px;
      --callout-title-color: ${c.base07};
      --callout-title-size: 1em;
      --callout-note: ${c.base0D};
      --callout-abstract: ${c.base0C};
      --callout-info: ${c.base0D};
      --callout-todo: ${c.base0D};
      --callout-tip: ${c.base0B};
      --callout-success: ${c.base0B};
      --callout-question: ${c.base0A};
      --callout-warning: ${c.base0A};
      --callout-failure: ${c.base08};
      --callout-danger: ${c.base08};
      --callout-bug: ${c.base08};
      --callout-example: ${c.base0E};
      --callout-quote: ${c.base04};

      --tab-background-active: ${c.base01};
      --tab-text-color: ${c.base04};
      --tab-text-color-active: ${c.base05};
      --tab-text-color-focused: ${c.base04};
      --tab-text-color-focused-active: ${c.base05};
      --tab-text-color-focused-highlighted: ${accent};
      --tab-text-color-focused-active-current: ${c.base07};
      --tab-text-color-inactive: ${c.base03};
      --tab-container-background: ${c.base00};
      --tab-outline-color: ${c.base02};
      --tab-divider-color: ${c.base02};
      --tab-curve: 0px;
      --tab-font-size: 0.9em;
      --tab-font-weight: 500;
      --tab-width: 200px;

      --titlebar-background: ${c.base00};
      --titlebar-background-focused: ${c.base00};
      --titlebar-text-color: ${c.base04};
      --titlebar-text-color-focused: ${c.base05};

      --ribbon-background: ${c.base00};
      --ribbon-background-collapsed: ${c.base00};
      --status-bar-background: ${c.base00};
      --status-bar-text-color: ${c.base04};
      --status-bar-border-color: ${c.base02};

      --nav-item-color: ${c.base04};
      --nav-item-color-hover: ${c.base05};
      --nav-item-color-active: ${c.base07};
      --nav-item-color-selected: ${c.base07};
      --nav-item-background-hover: ${c.base02};
      --nav-item-background-active: ${accentSurface};
      --nav-item-background-selected: ${accentSurfaceStrong};
      --nav-heading-color: ${c.base03};
      --nav-heading-color-hover: ${c.base05};
      --nav-collapse-icon-color: ${c.base03};
      --nav-collapse-icon-color-collapsed: ${c.base04};

      --menu-background: ${c.base01};
      --menu-color: ${c.base05};
      --menu-border-color: ${c.base02};
      --menu-item-background-hover: ${c.base02};
      --menu-item-color-hover: ${c.base07};
      --modal-background: ${c.base01};
      --modal-border-color: ${c.base02};
      --modal-border-width: 1px;
      --prompt-background: ${c.base01};
      --prompt-border-color: ${c.base02};
      --tooltip-background: ${c.base00};
      --tooltip-color: ${c.base05};

      --scrollbar-bg: transparent;
      --scrollbar-thumb-bg: ${c.base02};
      --scrollbar-active-thumb-bg: ${accent};

      --graph-line: ${c.base03};
      --graph-node: ${c.base0D};
      --graph-node-focused: ${accent};
      --graph-node-tag: ${c.base0E};
      --graph-node-attachment: ${c.base0A};
      --graph-node-unresolved: ${c.base04};
      --canvas-background: ${c.base01};
      --canvas-card-label-color: ${c.base05};
      --canvas-dot-pattern: ${c.base02};
      --canvas-color-1: ${c.base08};
      --canvas-color-2: ${c.base09};
      --canvas-color-3: ${c.base0A};
      --canvas-color-4: ${c.base0B};
      --canvas-color-5: ${c.base0D};
      --canvas-color-6: ${c.base0E};
    }

    body {
      background: ${c.base00};
      color: ${c.base05};
    }

    .workspace-leaf-content {
      background: ${c.base01};
    }

    .workspace-split.mod-left-split,
    .workspace-split.mod-right-split,
    .workspace-tab-header-container {
      background: ${c.base00};
    }

    .workspace-tab-header-container {
      border-bottom: 1px solid ${c.base02};
    }

    .workspace-tab-header.is-active {
      box-shadow: inset 0 -2px 0 ${accent};
    }

    .status-bar {
      border-top: 1px solid ${c.base02};
    }

    .markdown-source-view,
    .markdown-preview-view {
      background: ${c.base01};
    }

    .markdown-rendered h1 {
      border-bottom: 1px solid ${c.base02};
      padding-bottom: 0.2em;
    }

    .markdown-rendered blockquote {
      background: ${c.base02};
      color: ${c.base05};
      padding: 0.6em 1em;
    }

    .markdown-rendered code {
      border-radius: 0;
      padding: 0.1em 0.3em;
    }

    .markdown-rendered pre {
      background: ${c.base01};
      border: 1px solid ${c.base02};
      border-radius: 0;
      padding: 1em;
    }

    .markdown-rendered pre code {
      background: transparent;
      color: ${c.base05};
    }

    .markdown-rendered hr {
      border: none;
      border-top: 1px solid ${c.base02};
    }

    .markdown-rendered th,
    .markdown-rendered td {
      border: 1px solid ${c.base02};
    }

    .markdown-rendered thead {
      background: ${c.base02};
    }

    .markdown-rendered mark {
      background: #d4bf9440;
      color: ${c.base07};
    }

    .markdown-rendered .task-list-item-checkbox {
      border-radius: 0;
    }

    .callout {
      border-radius: 0;
    }

    .callout[data-callout="note"],
    .callout[data-callout="info"],
    .callout[data-callout="todo"] {
      border-left: 3px solid ${c.base0D};
    }

    .callout[data-callout="tip"],
    .callout[data-callout="success"] {
      border-left: 3px solid ${c.base0B};
    }

    .callout[data-callout="warning"],
    .callout[data-callout="question"] {
      border-left: 3px solid ${c.base0A};
    }

    .callout[data-callout="danger"],
    .callout[data-callout="error"],
    .callout[data-callout="failure"],
    .callout[data-callout="bug"] {
      border-left: 3px solid ${c.base08};
    }

    .cm-s-obsidian .cm-keyword { color: ${c.base0E}; }
    .cm-s-obsidian .cm-string { color: ${c.base0B}; }
    .cm-s-obsidian .cm-number { color: ${c.base09}; }
    .cm-s-obsidian .cm-comment { color: ${c.comment}; font-style: italic; }
    .cm-s-obsidian .cm-def { color: ${c.base0D}; }
    .cm-s-obsidian .cm-operator { color: ${c.base0C}; }
    .cm-s-obsidian .cm-property { color: ${c.base0A}; }
    .cm-s-obsidian .cm-atom { color: ${c.base09}; }
    .cm-s-obsidian .cm-tag { color: ${c.base08}; }
    .cm-s-obsidian .cm-variable { color: ${c.base05}; }

    button,
    .mod-cta,
    .mod-warning {
      border-radius: 0;
    }

    button.mod-cta {
      background: ${accent};
      color: ${c.base07};
    }

    button.mod-cta:hover {
      background: ${accentHover};
    }

    :focus-visible {
      outline: 1px solid ${accent};
      outline-offset: 2px;
    }

    ::selection {
      background: ${c.selection};
      color: ${c.base07};
    }

    ::-webkit-scrollbar {
      width: 10px;
      height: 10px;
    }

    ::-webkit-scrollbar-track {
      background: ${c.base00};
    }

    ::-webkit-scrollbar-thumb {
      background: ${c.base02};
      border: 2px solid ${c.base00};
      border-radius: 0;
    }

    ::-webkit-scrollbar-thumb:hover {
      background: ${c.base03};
    }
  '';
in
{
  xdg.dataFile."rhodium/obsidian/chiaroscuro.css".text = css;

  home.activation.obsidian-theme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    set -eu

    cfg="$HOME/.config/obsidian/obsidian.json"
    snippet="${config.xdg.dataHome}/rhodium/obsidian/chiaroscuro.css"
    jq="${pkgs.jq}/bin/jq"
    coreutils="${pkgs.coreutils}/bin"

    [ -f "$cfg" ] || exit 0
    [ -f "$snippet" ] || exit 0

    "$jq" -r '.vaults // {} | .[].path' "$cfg" | while IFS= read -r vault; do
      [ -n "$vault" ] || continue
      [ -d "$vault/.obsidian" ] || continue

      "$coreutils/mkdir" -p "$vault/.obsidian/snippets"
      "$coreutils/install" -m 0644 "$snippet" "$vault/.obsidian/snippets/chiaroscuro.css"

      appearance="$vault/.obsidian/appearance.json"
      tmp="$("$coreutils/mktemp")"
      if [ -f "$appearance" ]; then
        if "$jq" '
          .["enabledCssSnippets"] = (((.["enabledCssSnippets"] // []) + ["chiaroscuro"]) | unique)
          | .theme = "obsidian"
          | .cssTheme = ""
          | .accentColor = ""
        ' "$appearance" > "$tmp"; then
          "$coreutils/mv" "$tmp" "$appearance"
        else
          echo "obsidian-theme: could not update $appearance (invalid JSON?)" >&2
          "$coreutils/rm" -f "$tmp"
        fi
      else
        "$jq" -n '{
          theme: "obsidian",
          cssTheme: "",
          accentColor: "",
          enabledCssSnippets: ["chiaroscuro"]
        }' > "$appearance"
      fi
    done
  '';
}
