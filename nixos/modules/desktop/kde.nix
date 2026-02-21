{ inputs, ... }:
{
  flake.modules.nixos.kde =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.local.desktop.kde;
    in
    {
      options.local.desktop.kde.enable = lib.mkEnableOption "KDE Plasma desktop environment";

      config = lib.mkIf cfg.enable {
        services.desktopManager.plasma6.enable = true;
        services.displayManager.plasma-login-manager.enable = true;
        services.xserver.enable = false;

        environment.sessionVariables = {
          # Força Wayland em apps Electron/Chromium
          NIXOS_OZONE_WL = "1";
          # Força Qt a usar Wayland
          QT_QPA_PLATFORM = "wayland";
          # Força SDL a usar Wayland
          SDL_VIDEODRIVER = "wayland";
          # Força apps clutter/GDK a usar Wayland
          GDK_BACKEND = "wayland";
          # Força Java/AWT a usar Wayland via XWayland — remover se xwayland desabilitado
          # _JAVA_AWT_WM_NONREPARENTING = "1";
        };

        environment.plasma6.excludePackages = with pkgs.kdePackages; [
          elisa
          gwenview
          khelpcenter
          kmail
          kontact
          konsole
          korganizer
          marble
          oxygen
          print-manager
        ];

        environment.systemPackages = with pkgs.kdePackages; [
          # ark
          # dolphin
          # filelight
          # kate
          # kcalc
          # partitionmanager
          # spectacle
        ];
      };
    };

  flake.modules.homeManager.kde =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.local.desktop.kde;
    in
    {
      imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

      options.local.desktop.kde.enable = lib.mkEnableOption "KDE home-manager configuration";

      config = lib.mkIf cfg.enable {
        programs.plasma = {
          enable = true;

          workspace = {
            lookAndFeel = "org.kde.breezedark.desktop";
            colorScheme = "BreezeDark";
            iconTheme = "Papirus-Dark";
            cursor = {
              theme = "Bibata-Modern-Classic";
              size = 24;
            };
          };

          # fonts = {
          #   general = {
          #     family = "Noto Sans";
          #     pointSize = 10;
          #   };
          #   fixedWidth = {
          #     family = "JetBrainsMono Nerd Font";
          #     pointSize = 12;
          #   };
          # };

          panels = [
            {
              location = "bottom";
              floating = true;
              widgets = [
                "org.kde.plasma.kickoff"
                "org.kde.plasma.icontasks"
                "org.kde.plasma.marginsseparator"
                "org.kde.plasma.systemtray"
                "org.kde.plasma.digitalclock"
              ];
            }
          ];

          # kwin = {
          #   borderlessMaximizedWindows = true;
          #   effects = {
          #     blur = {
          #       enable = true;
          #       strength = 7;
          #       noiseStrength = 1;
          #     };
          #     translucency.enable = true;
          #     wobblyWindows.enable = false;
          #   };
          #   nightLight = {
          #     enable = true;
          #     mode = "times";
          #     temperature = {
          #       day = 6500;
          #       night = 4700;
          #     };
          #     time = {
          #       evening = "18:00";
          #       morning = "06:00";
          #     };
          #   };
          #   virtualDesktops = {
          #     number = 4;
          #     rows = 1;
          #   };
          # };

          input = {
            keyboard = {
              layouts = [
                {
                  layout = "us";
                  variant = "intl";
                }
              ];
              repeatDelay = 300;
              repeatRate = 50;
              numlockOnStartup = "on";
            };
          };

          # hotkeys.commands = {
          #   "launch-ghostty" = {
          #     name = "Launch Ghostty";
          #     key = "Meta+Return";
          #     command = "ghostty";
          #   };
          #   "launch-dolphin" = {
          #     name = "Launch Dolphin";
          #     key = "Meta+E";
          #     command = "dolphin";
          #   };
          # };

          # shortcuts = {
          #   kwin = {
          #     "Switch to Desktop 1" = "Meta+1";
          #     "Switch to Desktop 2" = "Meta+2";
          #     "Switch to Desktop 3" = "Meta+3";
          #     "Switch to Desktop 4" = "Meta+4";
          #     "Window to Desktop 1" = "Meta+Shift+1";
          #     "Window to Desktop 2" = "Meta+Shift+2";
          #     "Window to Desktop 3" = "Meta+Shift+3";
          #     "Window to Desktop 4" = "Meta+Shift+4";
          #     "Window Close" = "Alt+F4";
          #     "Window Maximize" = "Meta+Up";
          #     "Window Minimize" = "Meta+Down";
          #   };
          # };

          configFile = {
            # Clique duplo para abrir arquivos
            "kdeglobals"."KDE"."SingleClick".value = false;
            # Evitar que o KDE sobrescreva as configurações do plasma-manager
            # "kwinrc"."Compositing"."Backend".value = "OpenGL";
            # "kwinrc"."Compositing"."GLCore".value = true;
          };
        };
      };
    };
}
