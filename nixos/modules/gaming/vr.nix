_: {
  flake.modules.nixos.vr =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.local.gaming.vr;
    in
    {
      options.local.gaming.vr.enable = lib.mkEnableOption "VR support (Envision and WiVRn)";

      config = lib.mkIf cfg.enable {
        services.wivrn = {
          enable = true;
          openFirewall = true;
          defaultRuntime = true;
          autoStart = false;
          # steam.importOXRRuntimes = true;
        };

        environment.systemPackages = with pkgs; [
          wayvr
        ];
      };
    };
}
