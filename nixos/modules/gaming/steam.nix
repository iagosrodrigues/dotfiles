{ ... }:
{
  flake.modules.nixos.steam =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        package = pkgs.steam.override {
          extraEnv = {
            MANGOHUD = false;
            MANGOHUD_CONFIG = "full,core_load=0";
            ENABLE_VKBASALT = false;
            PROTON_USE_NTSYNC = false;
            PROTON_USE_WOW64 = false;
            PROTON_ENABLE_HDR = false;
            PROTON_ENABLE_WAYLAND = false;
            PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES = true;
          };
        };
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = false;
        protontricks.enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };

      # Bind-mount Steam Downloads to ~/Downloads
      fileSystems."/home/iago/.local/share/Steam/Downloads" = {
        device = "/home/iago/Downloads";
        options = [
          "bind"
          "nofail"
        ];
      };
    };
}
