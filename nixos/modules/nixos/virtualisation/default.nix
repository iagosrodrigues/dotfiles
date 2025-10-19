{
  config,
  lib,
  ...
}: let
  cfg = config.local.virtualisation;
in {
  options.local.virtualisation = with lib; {
    enable = mkEnableOption "Virtualisation";
    description = "Enable virtualisation";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;

    programs.virt-manager.enable = true;
  };
}
