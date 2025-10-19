{
  config,
  lib,
  ...
}: let
  cfg = config.local.tuning;
in {
  options.local.tuning = with lib; {
    enable = mkEnableOption "Tuning";
    description = "Enable tuning";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      settings.auto-optimise-store = true;
      settings.warn-dirty = false;

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };

      optimise.automatic = true;
    };
  };
}
