{ inputs, config, ... }:
let
  nixosModules = builtins.attrValues config.flake.modules.nixos;
  hmModules = builtins.attrValues config.flake.modules.homeManager;
in
{
  flake.nixosConfigurations.darkplace = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = nixosModules ++ [ { home-manager.sharedModules = hmModules; } ];
  };
}
