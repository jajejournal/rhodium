{
  description = "Rhodium | A Hypermodular NixOS System";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.11";
    };

    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    # NOTE: We define a separate source for NixShells since we might want dev tools with newer nixos package versions without bumping entire derivation
    nixpkgs-shell = {
      url = "github:NixOS/nixpkgs/nixos-25.11";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kanso-nvim = {
      url = "github:pabloagn/kanso.nvim"; # NOTE: Personal fork
      flake = false;
    };

    chiaroscuro = {
      url = "github:pabloagn/chiaroscuro.rht";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rhodium-alloys = {
      url = "github:pabloagn/alloys.rhf";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rhodium-opencode = {
      url = "github:jajejournal/rhodium-opencode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-shell,
      home-manager,
      flake-parts,
      sops-nix,
      nur,
      zen-browser,
      kanso-nvim,
      chiaroscuro,
      rhodium-alloys,
      niri-flake,
      rhodium-opencode,
    }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";

      # Import overlays with inputs
      overlaysWithInputs = import ./overlays { inherit inputs; };

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          input-fonts.acceptLicense = true;
          permittedInsecurePackages = [
            "jitsi-meet-1.0.8043"
            "electron-36.9.5"
          ];
        };
        overlays = [
          nur.overlays.default
          overlaysWithInputs.fonts
          rhodium-opencode.overlays.default
        ];
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [
          nur.overlays.default
          overlaysWithInputs.fonts
          rhodium-opencode.overlays.default
        ];
      };

      pkgs-shell = import nixpkgs-shell {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      rhodiumLib = import ./lib { inherit lib pkgs; };

      # Data paths
      dataPath = ./data;
      dataPathUsers = dataPath + "/users/";
      dataPathUserExtras = dataPathUsers + "/extras/";
      dataPathUserPreferences = dataPathUsers + "/preferences/";
      dataPathHosts = dataPath + "/hosts/";

      # Import user data
      userData =
        if builtins.pathExists (dataPathUsers + "/users.nix") then
          (import (dataPathUsers + "/users.nix")).users
        else
          { };

      # Import user preferences
      userPreferences =
        if builtins.pathExists dataPathUserPreferences then (import dataPathUserPreferences) else { };

      # Import and pack all user extras data
      userExtras = {
        path = dataPathUserExtras;

        bookmarksData =
          if builtins.pathExists (dataPathUserExtras + "/bookmarks.nix") then
            import (dataPathUserExtras + "/bookmarks.nix")
          else
            { };

        profilesData =
          if builtins.pathExists (dataPathUserExtras + "/profiles.nix") then
            import (dataPathUserExtras + "/profiles.nix")
          else
            { };

        appsData =
          if builtins.pathExists (dataPathUserExtras + "/apps.nix") then
            import (dataPathUserExtras + "/apps.nix")
          else
            { };

        osmiumData =
          if builtins.pathExists (dataPathUserExtras + "/osmium.nix") then
            import (dataPathUserExtras + "/osmium.nix")
          else
            { };
      };

      # Import host data
      hostData =
        if builtins.pathExists (dataPathHosts + "/hosts.nix") then
          (import (dataPathHosts + "/hosts.nix")).hosts
        else
          { };

      # Theme selection
      getThemeConfig =
        themeName: variant:
        let
          themePath = ./home/assets/themes + "/${themeName}.nix";
          themeConfig =
            if builtins.pathExists themePath then
              import themePath { inherit pkgs; }
            else
              import ./home/assets/themes/chiaroscuro.nix { inherit pkgs; };
        in
        if variant == "light" && themeConfig.theme ? light then
          themeConfig.theme.light
        else
          themeConfig.theme.dark;

      # User's theme preferences with fallbacks
      userThemeName = userPreferences.theme.name or "chiaroscuro";
      userThemeVariant = userPreferences.theme.variant or "dark";
      selectedTheme = getThemeConfig userThemeName userThemeVariant;

      # TODO: Temporary theme imports
      # While we have the complete theme module set up
      targetTheme = import ./home/modules/themes.nix { inherit pkgs inputs; };

      chiaroscuroTheme = inputs.chiaroscuro.themes.kanso-zen;
    in
    {
      # --- Overlays ---
      overlays = import ./overlays { inherit inputs; };

      # --- Formatter ---
      formatter.${system} = pkgs.nixfmt-rfc-style;

      # --- Nixos ---
      nixosConfigurations =
        let
          # Build a complete NixOS configuration for a host.
          #   hostKey -> key in data/hosts/hosts.nix (also the dir name under ./hosts)
          # The user is resolved from data/hosts/hosts.nix (`user = "user_xxx"`),
          # falling back to the first defined user.
          mkHost =
            hostKey:
            let
              userKey =
                (hostData.${hostKey} or { }).user or (builtins.head (builtins.attrNames userData));
            in
            lib.nixosSystem {
              inherit system pkgs;
              modules = [
                ./hosts/${hostKey}
                home-manager.nixosModules.home-manager
                niri-flake.nixosModules.niri
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    backupFileExtension = "backup";

                    users.${userData.${userKey}.username} = import ./users/user_001;

                    extraSpecialArgs = {
                      inherit
                        pkgs-unstable
                        inputs
                        rhodiumLib
                        userData
                        ;
                      user = userData.${userKey} or { };
                      host = hostData.${hostKey} or { };
                      theme = selectedTheme;
                      targetTheme = targetTheme; # TODO: This is temporary
                      chiaroscuroTheme = chiaroscuroTheme; # TODO: This is temporary
                      inherit userPreferences userExtras;
                      fishPlugins = rhodium-alloys.fish;
                      yaziPlugins = rhodium-alloys.yazi;
                      inherit (rhodiumLib.generators.moduleGenerators) mkModule mkPkgModule;
                    };
                  };
                }
              ];
              specialArgs = {
                inherit pkgs-unstable inputs rhodiumLib;
                users = userData;
                host = hostData.${hostKey} or { };
              };
            };
        in
        {
          amd = mkHost "amd";
          intel = mkHost "intel";
          generic = mkHost "generic";
        };

      # --- Standalone Home Configurations (testing) ---
      homeConfigurations = {
        ${userData.user_amd.username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./users/user_001
            niri-flake.homeModules.config
          ];
          extraSpecialArgs = {
            inherit
              pkgs-unstable
              inputs
              rhodiumLib
              userData
              ;
            user = userData.user_amd or { };
            host = { };
            theme = selectedTheme;
            targetTheme = targetTheme; # TODO: This is temporary
            inherit userPreferences userExtras;
            fishPlugins = rhodium-alloys.fish;
            yaziPlugins = rhodium-alloys.yazi;
          };
        };
      };

      # --- Devshells ---
      devShells.${system} = {
        # Default
        default = import ./devshells/nixos.nix { inherit pkgs-shell pkgs-unstable inputs lib; };
      };
    };
}
