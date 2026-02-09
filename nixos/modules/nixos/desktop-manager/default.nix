{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.desktopManager;
in {
  options.local.desktopManager = {
    enable = lib.mkEnableOption "Enable Desktop Manager";

    value = lib.mkOption {
      type = lib.types.enum ["gnome" "plasma"];
      default = "gnome";
      description = ''
        Choose your desktop environment.
        Valid options are "gnome" and "plasma".
      '';
    };

    videoDriver = lib.mkOption {
      type = lib.types.enum ["amdgpu" "intel" "nvidia"];
      default = "amdgpu";
      description = "Choose your GPU driver.";
    };

    waylandSupport = lib.mkEnableOption "Enable Wayland support for the chosen desktop environment";
  };

  config = lib.mkIf cfg.enable {
    # Enable the X11 windowing system.
    services.xserver = {
      enable = false;
      videoDrivers = [cfg.videoDriver];
      xkb = {
        layout = "us";
        variant = "intl";
      };
    };

    # GNOME configuration
    services.displayManager.gdm.enable = lib.mkIf (cfg.value == "gnome") true;
    services.displayManager.gdm.wayland = lib.mkIf (cfg.value == "gnome" && cfg.waylandSupport) true;
    services.displayManager.gdm.autoSuspend = false;
    services.desktopManager.gnome.enable = lib.mkIf (cfg.value == "gnome") true;

    # KDE Plasma configuration
    services.displayManager.sddm.enable = lib.mkIf (cfg.value == "plasma") true;
    services.displayManager.sddm.wayland.enable = lib.mkIf (cfg.value == "plasma" && cfg.waylandSupport) true;
    services.desktopManager.plasma6.enable = lib.mkIf (cfg.value == "plasma") true;

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
      # gnomeExtensions.blur-my-shell
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
}
