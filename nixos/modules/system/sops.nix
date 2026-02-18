{ inputs, ... }:
{
  flake.modules.nixos.sops = {
    imports = [ inputs.sops-nix.nixosModules.sops ];

    # Configuracao basica do SOPS
    # sops.defaultSopsFile = ./secrets.yaml;
    # sops.age.keyFile = "/var/lib/sops-nix/key.txt";

    # Exemplo de como declarar um secret:
    # sops.secrets.meu-secret = { };
  };
}
