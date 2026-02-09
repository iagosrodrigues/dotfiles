{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.pkgs.nixfmt;

      devShells.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          deadnix
          nil
          nixfmt
          statix
        ];

        shellHook = ''
          echo "NixOS development environment"
          echo "Available commands: alejandra, deadnix, nixpkgs-fmt, statix, nil"
        '';
      };
    };
}
