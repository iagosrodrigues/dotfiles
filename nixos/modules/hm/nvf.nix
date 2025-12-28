{
  config,
  lib,
  ...
}: let
  cfg = config.local.term.nvf;
in {
  options.local.term.nvf.enable = lib.mkEnableOption "Enable nvf";
  config = lib.mkIf cfg.enable {
    programs.nvf.enable = true;
  };
}
