{
  config,
  lib,
  ...
}: let
  cfg = config.local.infinality;
in {
  options.local.infinality.enable = lib.mkEnableOption "Enable Infinality font configuration";
  config = lib.mkIf cfg.enable {
    environment.variables = {
      FREETYPE_PROPERTIES = lib.concatStringsSep " " [
        "truetype:interpreter-version=38"
        "autofitter:warping=1"
        "autofitter:no-stem-darkening=0"
        "cff:no-stem-darkening=0"
        "t1cid:no-stem-darkening=0"
        "type1:no-stem-darkening=0"
      ];
    };

    fonts = {
      fontconfig = {
        antialias = lib.mkDefault true;
        hinting = {
          enable = lib.mkDefault true;
          style = lib.mkDefault "slight";
        };
        subpixel = {
          lcdfilter = lib.mkDefault "none";
          rgba = lib.mkDefault "none";
        };
      };
    };
  };
}
