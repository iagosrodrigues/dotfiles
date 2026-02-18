_: {
  flake.modules.nixos.steam =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.local.gaming.steam;
    in
    {
      options.local.gaming.steam.enable = lib.mkEnableOption "Steam gaming platform";

      config = lib.mkIf cfg.enable {
        programs.steam = {
          enable = true;
          package = pkgs.steam.override {
            extraEnv = {
              MANGOHUD = true;
              MANGOHUD_CONFIG = "full,core_load=0";
              PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES = 1;
              # ENABLE_VKBASALT = false;
              # PROTON_USE_NTSYNC = false;
              # PROTON_USE_WOW64 = false;
              # PROTON_ENABLE_HDRI = false;
              # PROTON_ENABLE_WAYLAND = true;
            };
          };
          remotePlay.openFirewall = true;
          dedicatedServer.openFirewall = true;
          localNetworkGameTransfers.openFirewall = true;
          gamescopeSession.enable = false;
          protontricks.enable = true;
          extraCompatPackages = [ pkgs.proton-ge-bin ];
        };

      };
    };
}
