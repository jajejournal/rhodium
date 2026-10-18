let
  categories = {
    utils = "utils";
    productivity = "productivity";
    reference = "reference";
    news = "news";
    repositories = "repositories";
    design = "design";
  };
in
{
  # Starter bookmarks. Every entry becomes a launchable desktop entry in the
  # rice's own menus (fuzzel-apps.sh, raffi). They are deliberately hidden from
  # the generic app menu, so Mod + A stays a list of applications -- see
  # home/modules/desktop.nix.
  #
  # Add your own: a group is just a namespace; each entry needs the browser
  # profile it should open with (`profile`, see data/users/preferences/apps.nix),
  # a url, a description and optional categories.
  #
  #   mygroup = {
  #     mysite = {
  #       profile = "personal";
  #       url = "https://example.com";
  #       description = "Example";
  #       categories = [ categories.utils ];
  #     };
  #   };
  reference = {
    nixos-search = {
      profile = "personal";
      url = "https://search.nixos.org";
      description = "NixOS Search";
      categories = [ categories.reference ];
    };
    nixos-wiki = {
      profile = "personal";
      url = "https://wiki.nixos.org";
      description = "NixOS Wiki";
      categories = [ categories.reference ];
    };
    mynixos = {
      profile = "personal";
      url = "https://mynixos.com";
      description = "MyNixOS";
      categories = [ categories.reference ];
    };
    arch-wiki = {
      profile = "personal";
      url = "https://wiki.archlinux.org";
      description = "Arch Wiki";
      categories = [ categories.reference ];
    };
  };

  dev = {
    github = {
      profile = "personal";
      url = "https://github.com";
      description = "GitHub";
      categories = [ categories.repositories ];
    };
    nixpkgs = {
      profile = "personal";
      url = "https://github.com/NixOS/nixpkgs";
      description = "Nixpkgs";
      categories = [ categories.repositories ];
    };
    repology = {
      profile = "personal";
      url = "https://repology.org";
      description = "Repology";
      categories = [ categories.utils ];
    };
  };
}
