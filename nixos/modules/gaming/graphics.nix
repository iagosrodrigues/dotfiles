_: {
  flake.modules.nixos.gaming-graphics =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.local.gaming.graphics;
    in
    {
      options.local.gaming.graphics.enable = lib.mkEnableOption "Gaming graphics support (Vulkan, ROCm)";

      config = lib.mkIf cfg.enable {
        hardware.graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = with pkgs; [
            libva
            rocmPackages.clr.icd
          ];
        };
      };
    };
}
