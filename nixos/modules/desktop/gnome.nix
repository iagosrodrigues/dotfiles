_: {
  flake.modules.nixos.gnome =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.local.desktop.gnome;
    in
    {
      options.local.desktop.gnome.enable = lib.mkEnableOption "GNOME desktop environment";

      config = lib.mkIf cfg.enable {
        services = {
          xserver = {
            enable = false;
            videoDrivers = [ "amdgpu" ];
            xkb = {
              layout = "us";
              variant = "intl";
            };
          };

          displayManager.gdm = {
            enable = true;
            wayland = true;
            autoSuspend = false;
          };

          desktopManager.gnome.enable = true;
        };

        environment.gnome.excludePackages = with pkgs; [
          decibels
          epiphany
          geary
          gnome-connections
          gnome-console
          gnome-contacts
          gnome-logs
          gnome-maps
          gnome-music
          gnome-terminal
          gnome-tour
          gnome-user-docs
          gnome-user-share
          showtime
          simple-scan
          totem
          yelp
        ];

        environment.systemPackages = with pkgs; [
          gnomeExtensions.appindicator
          gnomeExtensions.astra-monitor
          gnomeExtensions.bluetooth-battery-meter
          gnomeExtensions.clipboard-indicator
          gnomeExtensions.dash-to-dock
          gnomeExtensions.simpleweather
          gnome-extension-manager
          gnome-shell-extensions
          gnome-tweaks
          nautilus
          resources
        ];
      };
    };

  flake.modules.homeManager.gnome =
    { config, lib, ... }:
    let
      cfg = config.local.desktop.gnome;
    in
    {
      options.local.desktop.gnome.enable = lib.mkEnableOption "GNOME home-manager configuration";

      config = lib.mkIf cfg.enable {
        dconf.settings = {
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = [
              "appindicatorsupport@rgcjonas.gmail.com"
              "clipboard-indicator@tudmotu.com"
              "dash-to-dock@micxgx.gmail.com"
            ];
            favorite-apps = [
              "brave-browser.desktop"
              "com.mitchellh.ghostty.desktop"
              "dev.zed.Zed.desktop"
              "org.telegram.desktop.desktop"
              "steam.desktop"
            ];
          };

          "org/gnome/desktop/wm/preferences" = {
            button-layout = "appmenu:minimize,maximize,close";
          };

          "org/gnome/desktop/input-sources" = {
            sources = [
              (lib.gvariant.mkTuple [
                "xkb"
                "us+intl"
              ])
            ];
          };

          "org/gnome/desktop/interface" = {
            force = true;
            color-scheme = "prefer-dark";
          };

          "org/gnome/desktop/peripherals/mouse" = {
            accel-profile = "flat";
            speed = 1.0;
          };

          "org/gnome/mutter" = {
            experimental-features = [
              "scale-monitor-framebuffer"
            ];
          };

          "org/gnome/nautilus/list-view" = {
            default-column-order = [
              "name"
              "size"
              "type"
              "owner"
              "group"
              "permissions"
              "date_modified"
              "date_accessed"
              "date_created"
              "recency"
              "detailed_type"
            ];
            default-visible-columns = [
              "name"
              "size"
              "type"
              "date_modified"
            ];
            default-zoom-level = "medium";
          };

          "org/gnome/shell/extensions/clipboard-indicator" = {
            history-size = 100;
            move-item-first = true;
          };

          "org/gnome/nautilus/preferences" = {
            default-folder-viewer = "list-view";
            migrated-gtk-settings = true;
            search-filter-time-type = "last_modified";
          };

          "org/gnome/settings-daemon/plugins/color" = {
            night-light-enabled = true;
            night-light-schedule-from = "18.0";
            night-light-schedule-to = "06.0";
            night-light-temperature = lib.gvariant.mkUint32 4700;
          };

          "org/gnome/desktop/peripherals/keyboard" = {
            delay = lib.gvariant.mkUint32 300;
            repeat-interval = lib.gvariant.mkUint32 20;
          };

          "org/gnome/shell/extensions/dash-to-dock" = {
            background-opacity = 0.8;
            custom-theme-shrink = true;
            dash-max-icon-size = 48;
            dock-position = "BOTTOM";
            height-fraction = 0.9;
            hot-keys = false;
            intellihide-mode = "MAXIMIZED_WINDOWS";
            preferred-monitor = -2;
            preferred-monitor-by-connector = "DP-1";
            show-apps-at-top = true;
          };
        };
      };
    };
}
