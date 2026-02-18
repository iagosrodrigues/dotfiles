_: {
  flake.modules.nixos.darkplace-features = {
    local = {
      # Hardware
      hardware.yubikey.enable = true;
      gaming = {

        # Gaming
        steam.enable = true;
        vr.enable = true;
        gamemode.enable = false;
        graphics.enable = true;
      };

      # Desktop
      desktop.gnome.enable = true;
      desktop.niri.enable = true;

      # Apps
      apps.onepassword.enable = true;

      # System
      system.virtualisation.enable = true;
      system.lact.enable = true;
    };

    networking.hostName = "darkplace";
  };

  flake.modules.homeManager.darkplace-features = {
    local = {
      desktop = {
        # Desktop
        gnome.enable = true;
        niri.enable = true;
        ashell.enable = true;
      };
    };
  };
}
