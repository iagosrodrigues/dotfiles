{
  description = "Main NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-cursor-pr.url = "github:jetpham/nixpkgs/update-cursor-2.0.38";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    nur.url = "github:nix-community/NUR";

    # nix-community
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";

    impermanence.url = "github:nix-community/impermanence";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # lanzaboote = {
    #   url = "github:nix-community/lanzaboote";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra = {
      url = "github:kamadorueda/alejandra/4.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
  };

  outputs = inputs: let
    inherit (builtins) attrNames attrValues mapAttrs;
    inherit (inputs.nixpkgs) lib legacyPackages;
    localLib = import ./lib {inherit inputs;};
    discoveredHosts = localLib.mapHosts ./hosts;
    discoveredUsers = localLib.mapUsers ./users;
    discoveredNixosModules = localLib.discoverModules ./modules/nixos;
    discoveredHomeModules = localLib.discoverModules ./modules/home-manager;
    discoveredPackages = localLib.mapPackages ./packages;
    userModule = {
      config,
      pkgs,
      localLib,
      ...
    } @ moduleArgs: {
      users.users =
        mapAttrs (
          username: userData: let
            userAttrsFromFile = import userData.defaultNixPath moduleArgs;
          in
            lib.recursiveUpdate userAttrsFromFile {}
        )
        discoveredUsers;
      home-manager.users =
        mapAttrs (
          username: userData: (import userData.homeConfigPath {
            inherit
              username
              pkgs
              config
              lib
              ;
            hmLib = inputs.home-manager.lib;
          })
        )
        discoveredUsers;
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.sharedModules = attrValues discoveredHomeModules;
      # home-manager.backupFileExtension = "backup";
    };
  in {
    lib = localLib;
    nixosModules =
      discoveredNixosModules
      // {
        generateUsers = userModule;
      };
    homeModules = discoveredHomeModules;
    formatter = localLib.forAllSystems (system: legacyPackages.${system}.alejandra);
    packages = localLib.forAllSystems (
      system: let
        pkgs = legacyPackages.${system};
      in
        mapAttrs (name: pkgFunc: pkgFunc {inherit pkgs;}) discoveredPackages
    );
    nixosConfigurations =
      mapAttrs (
        hostname: hostData: let
          hostAttrs = hostData.hostAttrs;
          system = hostAttrs.system;
          hostSpecificSpecialArgs = hostAttrs.specialArgs or {};
          hostSpecificModules = hostAttrs.modules or [];
          specialArgs =
            {
              inherit
                hostname
                inputs
                localLib
                system
                ;
            }
            // hostSpecificSpecialArgs;
          hasUsers = lib.length (attrNames discoveredUsers) > 0;
        in
          lib.nixosSystem {
            inherit system specialArgs;
            modules =
              hostSpecificModules
              ++ [
                hostData.mainConfig
                {
                  nixpkgs = {
                    config.allowUnfree = true;
                    overlays = [
                      inputs.nur.overlays.default
                      # Overlay to use code-cursor from PR #456882
                      (final: prev: {
                        code-cursor =
                          (import inputs.nixpkgs-cursor-pr {
                            inherit system;
                            config.allowUnfree = true;
                          }).code-cursor;
                      })
                    ];
                  };
                }
              ]
              ++ [inputs.chaotic.nixosModules.default]
              ++ (attrValues discoveredNixosModules)
              ++ (lib.optionals hasUsers [
                inputs.home-manager.nixosModules.home-manager
                userModule
              ]);
          }
      )
      discoveredHosts;
  };
}
