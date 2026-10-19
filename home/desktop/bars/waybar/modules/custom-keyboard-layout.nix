{
  waybarModules = {
    "custom/keyboard-layout" = {
      exec = "$XDG_BIN_HOME/waybar/rh-keyboard-layout.sh";
      interval = 1;
      tooltip = true;
      tooltip-format = "Click to switch keyboard layout";
      on-click = "niri msg action switch-layout next";
      on-click-right = "niri msg action switch-layout prev";
      format = "{}";
    };
  };
}
