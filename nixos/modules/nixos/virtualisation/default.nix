{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.virtualisation;
in {
  options.local.virtualisation = with lib; {
    enable = mkEnableOption "Virtualisation";
    description = "Enable virtualisation";
    docker.enable = mkOption {
      type = types.bool;
      default = cfg.enable;
      defaultText = lib.literalExpression "config.local.virtualisation.enable";
      description = "Enable Docker support";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation =
      {
        libvirtd.enable = true;
        spiceUSBRedirection.enable = true;
      }
      // lib.optionalAttrs cfg.docker.enable {
        docker.enable = true;
      };

    programs.virt-manager.enable = true;

    environment.systemPackages =
      lib.optionals cfg.docker.enable [pkgs.k3d pkgs.kubectl];
  };
}
