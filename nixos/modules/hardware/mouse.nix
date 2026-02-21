{ inputs, ... }:
{
  flake.modules.homeManager.mouse-config = _: {
    imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

    config = {
      programs.plasma.input.mice = [
        {
          enable = true;
          name = "Beken 2.4G Wireless Device";
          vendorId = "1d57";
          productId = "fa60";
          accelerationProfile = "none";
          acceleration = 1.0;
          naturalScroll = false;
        }
      ];
    };
  };
}
