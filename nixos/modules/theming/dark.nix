_: {
  flake.modules.homeManager.dark-theme =
    { pkgs, ... }:
    {
      qt = {
        enable = true;
      };

      gtk = {
        enable = true;
        colorScheme = "dark";

        font = {
          name = "Inter";
          size = 11;
        };

        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };

        theme = {
          name = "adw-gtk3-dark";
          package = pkgs.adw-gtk3;
        };

        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = true;
          gtk-decoration-layout = "icon:minimize,maximize,close";
          gtk-enable-animations = true;
        };

        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = true;
          gtk-decoration-layout = "icon:minimize,maximize,close";
          gtk-enable-animations = true;
        };
      };

      home.pointerCursor = {
        gtk.enable = true;
        name = "macOS";
        package = pkgs.apple-cursor;
        size = 48;
      };
    };
}
