{
  waybarModules = {
    "custom/rhodium" = {
      format = "Rh";
      tooltip = false;
      on-click = "sh -c \"$USERBIN_FUZZEL/fuzzel-apps.sh\"";
      on-click-right = "sh -c \"$USERBIN_FUZZEL/fuzzel-apps.sh\"";
    };
  };
}
