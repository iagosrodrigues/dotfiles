{ ... }:
{
  flake.modules.nixos.gaming-graphics =
    { pkgs, ... }:
    {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          libva
          rocmPackages.clr.icd
        ];
      };
    };
}
