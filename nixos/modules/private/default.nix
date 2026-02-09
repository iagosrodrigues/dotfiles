{ inputs, ... }:
{
  flake.modules.nixos.private = inputs.private.nixosModules.default or { };
  flake.modules.homeManager.private = inputs.private.homeModules.default or { };
}
