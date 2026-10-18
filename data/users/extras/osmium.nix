# Internal / self-hosted services menu.
#
# `fuzzel-osmium.sh` reads these entries through
# ~/.local/share/rhodium-utils/osmium-bookmarks.json, so they stay separate
# from the regular bookmarks (data/users/extras/bookmarks.nix): this is the
# place for your router panel, dashboards, home servers, etc.
#
# Each entry needs:
#   profile     -> browser profile to open it with (see
#                  data/users/preferences/apps.nix; "" = default profile)
#   url         -> the service URL
#   description -> what the menu shows
#   categories  -> optional, free-form (only stored in the JSON)
#
# Example:
#
#   infrastructure = {
#     router = {
#       profile = "";
#       url = "https://192.168.1.1";
#       description = "Router";
#       categories = [ "infrastructure" ];
#     };
#   };
{
}
