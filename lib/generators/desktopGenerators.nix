{ lib, ... }:
let
  # We add a prefix for faster parsing later on
  entryPrefix = "rh";

  # Browser-specific argument templates
  browserConfigs = {
    firefox = {
      profileFlag = "-P";
      newWindowFlag = "-new-window";
      executable = "firefox";
    };

    zen = {
      profileFlag = "--profile";
      newWindowFlag = "--new-window";
      executable = "zen-browser";
    };

    chromium = {
      profileFlag = "--profile-directory";
      newWindowFlag = "--new-window";
      executable = "chromium";
    };

    brave = {
      profileFlag = "--profile-directory";
      newWindowFlag = "--new-window";
      executable = "brave";
    };
  };

  # Capitalize first letter for descriptions
  capitalize = str: lib.toUpper (lib.substring 0 1 str) + lib.substring 1 (-1) str;

  # An empty profile name means "use the browser's default profile": the
  # profile flag is left out, so entries keep working on a fresh install where
  # no named profile exists yet (set a name in data/users/preferences/apps.nix
  # to route a bookmark/profile to a specific one).
  profileArgs =
    browserConfig: profileName:
    lib.optionals (profileName != "") [
      browserConfig.profileFlag
      profileName
    ];

  # Flatten nested attribute set into flat structure with combined keys
  flattenNestedAttrs =
    attrs:
    lib.concatMapAttrs (
      topKey: topValue:
      lib.mapAttrs' (subKey: subValue: {
        name = "${entryPrefix}-${topKey}-${subKey}";
        # Keep the top-level group so entries without explicit categories can
        # still show a short label in the launcher (Media, Productivity, ...).
        value = subValue // {
          group = topKey;
        };
      }) topValue
    ) attrs;

  # Bookmark generator: Browser + profile + URL + special args
  mkBookmark =
    userPreferences: theme: name: bookmark:
    let
      defaultBrowser = userPreferences.apps.browser;
      browser = bookmark.browser or defaultBrowser;
      browserConfig = browserConfigs.${browser} or browserConfigs.${defaultBrowser};
      profileName = userPreferences.profiles.${browser}.${bookmark.profile} or bookmark.profile;
    in
    {
      binary = browserConfig.executable;
      args = profileArgs browserConfig profileName ++ [
        browserConfig.newWindowFlag
        bookmark.url
      ];
      icon = browser;
      description = "${bookmark.description}";
      entryType = "bookmark";
      profileName = profileName;
      categories = bookmark.categories or [ (capitalize bookmark.group) ];
    };

  # Profile generator: Browser + profile only + special args
  mkProfile =
    userPreferences: theme: name: profile:
    let
      defaultBrowser = userPreferences.apps.browser;
      browser = profile.browser or defaultBrowser;
      browserConfig = browserConfigs.${browser} or browserConfigs.${defaultBrowser};
      profileName = userPreferences.profiles.${browser}.${profile.profile} or profile.profile;
    in
    {
      binary = browserConfig.executable;
      args = profileArgs browserConfig profileName ++ [ browserConfig.newWindowFlag ];
      icon = browser;
      description =
        if profileName == "" then capitalize browser else "${capitalize browser} ${profileName}";
      entryType = "profile";
      profileName = profileName;
      categories = profile.categories or [ "Browser" ];
    };

  # App generator: Custom binary + flexible args + special args
  mkApp = userPreferences: theme: name: app: {
    binary = app.binary;
    args = app.args;
    icon = app.icon;
    description = "${app.description}";
    entryType = "application";
    categories = app.categories or [ (capitalize app.group) ];
    # Hides the entry from generic launchers. Set `noDisplay = true` for
    # entries that only duplicate the .desktop file the package already
    # installs; the rice's own menus (fuzzel-apps.sh, raffi) still list them.
    noDisplay = app.noDisplay or false;
  };
in
{
  inherit
    mkBookmark
    mkProfile
    mkApp
    flattenNestedAttrs
    ;

  generateAllEntries =
    userPreferences: userExtras: theme:
    let
      # Partially apply userPreferences to each generator function
      bookmarkGen = mkBookmark userPreferences theme;
      profileGen = mkProfile userPreferences theme;
      appGen = mkApp userPreferences theme;

      # Flatten nested structures and generate entries for each type
      bookmarkEntries = lib.mapAttrs bookmarkGen (flattenNestedAttrs userExtras.bookmarksData);
      profileEntries = lib.mapAttrs profileGen (flattenNestedAttrs userExtras.profilesData);
      appEntries = lib.mapAttrs appGen (flattenNestedAttrs userExtras.appsData);
    in
    bookmarkEntries // profileEntries // appEntries;
}
