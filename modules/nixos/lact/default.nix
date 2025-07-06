{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.local.programs.lact;
in {
  options.local.programs.lact = {
    enable = mkEnableOption "AMDGPU control software";
    config = mkOption {
      type = lib.types.attrs;
      description = "Configuration passed to LACT.";
      default = {};
      example = {
        daemon = {
          log_level = "info";
          admin_groups = [
            "wheel"
            "sudo"
          ];
          disable_clocks_cleanup = false;
          apply_settings_timer = 5;
        };
        gpus = {};
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      etc = mkIf (cfg.config != {}) {
        "lact/config.yaml".source = import ../../common/to-yaml.nix cfg.config;
      };
      systemPackages = [pkgs.lact];
    };
    systemd.services.lactd = {
      enable = true;
      description = "AMDGPU Control Daemon";
      after = ["multi-user.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = "${pkgs.lact}/bin/lact daemon";
        Nice = -10;
        Restart = "on-failure";
      };
    };
  };
}
