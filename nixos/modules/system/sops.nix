{ inputs, ... }:
{
  flake.modules.nixos.sops = {
    imports = [ inputs.sops-nix.nixosModules.sops ];

    # SOPS decrypts secrets at activation time using an age key.
    # The recommended setup for this machine uses age-plugin-tpm so the key is
    # sealed by the TPM — no passphrase required on boot.
    #
    # One-time setup (run on the target machine):
    #   nix shell nixpkgs#age-plugin-tpm
    #   age-plugin-tpm --generate -o /persist/var/lib/sops-nix/age-identity.txt
    #   age-plugin-tpm -y /persist/var/lib/sops-nix/age-identity.txt  # prints recipient
    #
    # Add the recipient to .sops.yaml at the repo root, then re-encrypt secrets:
    #   sops updatekeys secrets/<file>.yaml
    #
    # NixOS config (uncomment when secrets are ready):
    # sops.age.keyFile = "/persist/var/lib/sops-nix/age-identity.txt";
    # sops.defaultSopsFile = ./secrets.yaml;
    # sops.secrets.example = { };
  };
}
