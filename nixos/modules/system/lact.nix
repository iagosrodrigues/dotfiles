_: {
  flake.modules.nixos.lact =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.local.system.lact;
    in
    {
      options.local.system.lact.enable = lib.mkEnableOption "LACT AMD GPU control daemon";

      config = lib.mkIf cfg.enable {
        environment.systemPackages = [ pkgs.lact ];

        systemd.services.lact = {
          description = "AMDGPU Control Daemon";
          after = [ "multi-user.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = "${pkgs.lact}/bin/lact daemon";
            Nice = -10;
          };
        };
      };
    };
}
