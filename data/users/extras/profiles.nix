{
  # Browser profiles offered as launcher entries in the rice's own menus
  # (fuzzel-apps.sh, raffi). Each one becomes a desktop entry that opens the
  # browser directly in that profile.
  #
  # firefox.personal is required: home/environment/mime.nix uses its launcher
  # entry (rh-firefox-personal) as the default handler for web links.
  #
  # Add the profiles you actually use, e.g.:
  #
  #   firefox = {
  #     personal = { profile = "personal"; description = "Firefox Personal"; };
  #     work = { profile = "work"; description = "Firefox Work"; };
  #   };
  firefox = {
    personal = {
      profile = "personal";
      description = "Firefox Personal";
    };
  };
}
