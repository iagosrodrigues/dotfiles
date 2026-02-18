_: {
  flake.modules.nixos.networking = {
    networking = {
      networkmanager.enable = true;
    };

    time.timeZone = "America/Fortaleza";

    i18n = {
      defaultLocale = "en_US.UTF-8";
      inputMethod.enable = false;
    };

    console.keyMap = "us";

    services = {
      tailscale.enable = true;
      gnome.gnome-keyring.enable = true;
      timesyncd.enable = true;
      printing.enable = true;
    };
  };
}
