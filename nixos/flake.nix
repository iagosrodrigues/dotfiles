{
  description = "Main NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    impermanence.url = "github:nix-community/impermanence";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    alejandra = {
      url = "github:kamadorueda/alejandra/4.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hytale-launcher.url = "github:JPyke3/hytale-launcher-nix";

    # private = {
    #   url = "git+ssh://git@github.com/iagosrodrigues/nixos-private";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    private = {
      url = "path:/home/iago/personal/nixos-private";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri.url = "github:sodiboo/niri-flake";

    ashell.url = "github:MalpenZibo/ashell";

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };
  outputs = inputs: let
    inherit (builtins) attrNames attrValues mapAttrs;
    inherit (inputs.nixpkgs) lib legacyPackages;
    localLib = import ./lib {inherit inputs;};
    discoveredHosts = localLib.mapHosts ./hosts;
    discoveredUsers = localLib.mapUsers ./users;
    discoveredNixosModules = localLib.discoverModules ./modules/nixos;
    discoveredHomeModules = localLib.discoverModules ./modules/hm;
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
      home-manager = {
        users =
          mapAttrs (
            username: userData: (import userData.homeConfigPath {
              inherit
                username
                pkgs
                config
                lib
                inputs
                ;
              hmLib = inputs.home-manager.lib;
            })
          )
          discoveredUsers;
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules =
          attrValues discoveredHomeModules
          ++ [
            inputs.private.homeModules.default
            inputs.niri.homeModules.niri
          ];
      };
    };
  in {
    lib = localLib;
    homeModules = discoveredHomeModules;
    formatter = localLib.forAllSystems (system: legacyPackages.${system}.alejandra);
    packages = localLib.forAllSystems (
      system: let
        pkgs = legacyPackages.${system};
      in
        mapAttrs (name: pkgFunc: pkgFunc {inherit pkgs;}) discoveredPackages
    );

    devShells = localLib.forAllSystems (system: let
      pkgs = legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          alejandra
          deadnix
          nixpkgs-fmt
          nodejs
          statix
        ];
      };
    });

    nixosConfigurations =
      mapAttrs (
        hostname: hostData: let
          inherit (hostData) hostAttrs;
          inherit (hostAttrs) system;
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
                      inputs.niri.overlays.niri
                      inputs.ghostty.overlays.default
                    ];
                  };
                }
              ]
              ++ (attrValues discoveredNixosModules)
              ++ (lib.optionals hasUsers [
                inputs.home-manager.nixosModules.home-manager
                inputs.private.nixosModules.default
                userModule
              ]);
          }
      )
      discoveredHosts;
  };
}
