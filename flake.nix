{
  description = "Minha configuração do NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      # Defina o seu sistema (pode ser x86_64-linux, aarch64-linux, etc.)
      system = "x86_64-linux";
    in {
      # Declara as configurações do NixOS
      nixosConfigurations = {
        # Você pode mudar "my-host" para o nome que quiser
        gigawhite = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            # Módulos do seu NixOS
            ./nixos/configuration.nix

            # Integração com Home Manager
            home-manager.nixosModules.home-manager

            # Configuração do Home Manager para seu(s) usuário(s)
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              # Nome do usuário local. Altere se for diferente.
              home-manager.users.iago = import ./home/user.nix;
            }
          ];
        };
      };
    };
}

