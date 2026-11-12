{ ... }:
{
  programs.helix.themes = {
    kanso =
      let
        # Kanso (zen): the terminal/editor palette. Same colours as kitty,
        # ghostty, foot and kanso-nvim, so TUI work looks consistent.
        red = "#c4746e";
        orange = "#b6927b";
        yellow = "#c4b28a";
        light-green = "#87a987";
        green = "#7aa89f";
        aqua = "#7aa89f";
        teal = "#8ea4a2";
        turquoise = "#7aa89f";
        light-cyan = "#a4a7a4";
        cyan = "#7fb4ca";
        blue = "#8ba4b0";
        purple = "#938aa9";
        magenta = "#a292a3";
        comment = "#5c6066";
        black = "#22262d";

        add = "#87a987";
        change = "#7fb4ca";
        delete = "#e46876";

        error = "#e46876";
        info = "#7fb4ca";
        hint = "#87a987";

        fg = "#c5c9c7";
        fg-dark = "#a4a7a4";
        fg-gutter = "#5c6066";
        fg-linenr = "#a4a7a4";
        fg-selected = "#22262d";
        border = "#090e13";
        border-highlight = "#e6c384";
        bg = "#090e13";
        bg-inlay = "#0d1217";
        bg-selection = "#22262d";
        bg-menu = "#0d1217";
        bg-focus = "#1a2027";
      in
      {
        attribute = {
          fg = cyan;
        };
        comment = {
          fg = comment;
          modifiers = [ "italic" ];
        };
        "comment.block.documentation" = {
          fg = yellow;
        };
        constant = {
          fg = orange;
        };
        "constant.builtin" = {
          fg = aqua;
        };
        "constant.character" = {
          fg = light-green;
        };
        "constant.character.escape" = {
          fg = magenta;
        };
        constructor = {
          fg = aqua;
        };
        function = {
          fg = blue;
          modifiers = [ "italic" ];
        };
        "function.builtin" = {
          fg = aqua;
        };
        "function.macro" = {
          fg = cyan;
        };
        "function.special" = {
          fg = cyan;
        };
        keyword = {
          fg = purple;
          modifiers = [ "italic" ];
        };
        "keyword.control" = {
          fg = magenta;
        };
        "keyword.control.import" = {
          fg = cyan;
        };
        "keyword.control.return" = {
          fg = purple;
          modifiers = [ "italic" ];
        };
        "keyword.directive" = {
          fg = cyan;
        };
        "keyword.function" = {
          fg = magenta;
        };
        "keyword.operator" = {
          fg = magenta;
        };
        label = {
          fg = blue;
        };
        namespace = {
          fg = cyan;
        };
        operator = {
          fg = turquoise;
        };
        punctuation = {
          fg = turquoise;
        };
        special = {
          fg = aqua;
        };
        string = {
          fg = light-green;
        };
        "string.regexp" = {
          fg = light-cyan;
        };
        "string.special" = {
          fg = aqua;
        };
        tag = {
          fg = magenta;
        };
        type = {
          fg = aqua;
        };
        "type.builtin" = {
          fg = aqua;
        };
        "type.enum.variant" = {
          fg = orange;
        };
        variable = {
          fg = fg;
        };
        "variable.builtin" = {
          fg = red;
        };
        "variable.other.member" = {
          fg = green;
        };
        "variable.parameter" = {
          fg = yellow;
          modifiers = [ "italic" ];
        };

        "markup.bold" = {
          modifiers = [ "bold" ];
        };
        "markup.heading" = {
          fg = blue;
          modifiers = [ "bold" ];
        };
        "markup.heading.completion" = {
          bg = bg-menu;
          fg = fg;
        };
        "markup.heading.hover" = {
          bg = fg-selected;
        };
        "markup.italic" = {
          modifiers = [ "italic" ];
        };
        "markup.link" = {
          fg = blue;
          underline = {
            style = "line";
          };
        };
        "markup.link.label" = {
          fg = teal;
        };
        "markup.link.text" = {
          fg = teal;
        };
        "markup.link.url" = {
          underline = {
            style = "line";
          };
        };
        "markup.list" = {
          fg = orange;
          modifiers = [ "bold" ];
        };
        "markup.normal.completion" = {
          fg = comment;
        };
        "markup.normal.hover" = {
          fg = fg-dark;
        };
        "markup.raw" = {
          fg = teal;
        };
        "markup.raw.inline" = {
          bg = black;
          fg = blue;
        };
        "markup.strikethrough" = {
          modifiers = [ "crossed_out" ];
        };

        "diff.delta" = {
          fg = change;
        };
        "diff.delta.moved" = {
          fg = blue;
        };
        "diff.minus" = {
          fg = delete;
        };
        "diff.plus" = {
          fg = add;
        };

        error = {
          fg = error;
        };
        warning = {
          fg = yellow;
        };
        info = {
          fg = info;
        };
        hint = {
          fg = hint;
        };
        "diagnostic.error" = {
          underline = {
            style = "curl";
            color = error;
          };
        };
        "diagnostic.warning" = {
          underline = {
            style = "curl";
            color = yellow;
          };
        };
        "diagnostic.info" = {
          underline = {
            style = "curl";
            color = info;
          };
        };
        "diagnostic.hint" = {
          underline = {
            style = "curl";
            color = hint;
          };
        };
        "diagnostic.unnecessary" = {
          modifiers = [ "dim" ];
        };
        "diagnostic.deprecated" = {
          modifiers = [ "crossed_out" ];
        };

        "ui.background" = {
          fg = fg;
        };
        "ui.cursor" = {
          modifiers = [ "reversed" ];
        };
        "ui.cursor.match" = {
          fg = orange;
          modifiers = [ "bold" ];
        };
        "ui.cursorline.primary" = {
          bg = bg-menu;
        };
        "ui.help" = {
          bg = bg-menu;
          fg = fg;
        };
        "ui.linenr" = {
          fg = fg-gutter;
        };
        "ui.linenr.selected" = {
          fg = fg-linenr;
        };
        "ui.menu" = {
          bg = bg-menu;
          fg = fg;
        };
        "ui.menu.selected" = {
          bg = fg-selected;
        };
        "ui.popup" = {
          bg = bg-menu;
          fg = border-highlight;
        };
        "ui.selection" = {
          bg = bg-selection;
        };
        "ui.selection.primary" = {
          bg = bg-selection;
        };
        "ui.statusline" = {
          bg = bg-menu;
          fg = fg-dark;
        };
        "ui.statusline.inactive" = {
          bg = bg-menu;
          fg = fg-gutter;
        };
        "ui.statusline.normal" = {
          bg = blue;
          fg = bg;
          modifiers = [ "bold" ];
        };
        "ui.statusline.insert" = {
          bg = light-green;
          fg = bg;
          modifiers = [ "bold" ];
        };
        "ui.statusline.select" = {
          bg = magenta;
          fg = bg;
          modifiers = [ "bold" ];
        };
        "ui.text" = {
          fg = fg;
        };
        "ui.text.focus" = {
          bg = bg-focus;
        };
        "ui.text.inactive" = {
          fg = comment;
          modifiers = [ "italic" ];
        };
        "ui.text.info" = {
          bg = bg-menu;
          fg = fg;
        };
        "ui.text.directory" = {
          fg = cyan;
        };
        "ui.virtual.ruler" = {
          bg = fg-gutter;
        };
        "ui.virtual.whitespace" = {
          fg = fg-gutter;
        };
        "ui.virtual.inlay-hint" = {
          bg = bg-inlay;
          fg = teal;
        };
        "ui.virtual.jump-label" = {
          fg = orange;
          modifiers = [ "bold" ];
        };
        "ui.window" = {
          fg = border;
          modifiers = [ "bold" ];
        };

        "ui.bufferline" = {
          bg = bg;
          fg = comment;
        };
        "ui.bufferline.active" = {
          bg = bg-menu;
          fg = fg;
          modifiers = [ "bold" ];
        };
        "ui.bufferline.background" = {
          bg = bg;
        };

        "ui.virtual.indent-guide" = {
          fg = fg-gutter;
        };
        "ui.virtual.wrap" = {
          fg = fg-gutter;
        };

        "ui.highlight" = {
          bg = bg-selection;
        };
        "ui.picker.header" = {
          fg = blue;
          modifiers = [ "bold" ];
        };
        "ui.statusline.separator" = {
          fg = fg-gutter;
        };
        "ui.cursorcolumn.primary" = {
          bg = bg-menu;
        };

        "diagnostic.error.gutter" = {
          fg = error;
        };
        "diagnostic.warning.gutter" = {
          fg = yellow;
        };
        "diagnostic.info.gutter" = {
          fg = info;
        };
        "diagnostic.hint.gutter" = {
          fg = hint;
        };
      };
  };
}
