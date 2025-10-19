{
  lib,
  hmLib,
  pkgs,
  username,
  ...
}:
with hmLib.hm.gvariant; {
  programs = {
    home-manager = {
      enable = true;
    };

    mpv.enable = true;

    firefox = {
      enable = true;

      profiles.default = {
        isDefault = true;

        settings = {
          "signon.rememberSignons" = false;
          "signon.autofillForms" = false;
          "signon.formlessCapture.enabled" = false;

          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "extensions.formautofill.heuristics.enabled" = false;

          "places.history.enabled" = false; # Não manter histórico
          "browser.formfill.enable" = false; # Não lembrar dados de formulários
          "browser.urlbar.suggest.bookmark" = false;
          "browser.urlbar.suggest.history" = false;
          "browser.urlbar.suggest.openpage" = false;
          "browser.urlbar.suggest.topsites" = false;

          "browser.download.useDownloadDir" = false;
          "browser.cache.disk.enable" = false;
          "browser.cache.memory.enable" = true;

          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "identity.fxaccounts.enabled" = false; # Desativa conta Firefox Sync

          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "extensions.pocket.enabled" = false;
        };

        extensions = {
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            onepassword-password-manager
            ublock-origin
            privacy-badger
          ];
        };
      };
    };

    zed-editor = {
      enable = true;
      extensions = [
        "biome"
        "nix"
        "dockerfile"
        "docker-compose"
      ];
      userSettings = {
        buffer_font_family = "Maple Mono";
        buffer_font_size = 18;
        vim_mode = true;
        lsp = {
          biome = {
            binary = {
              arguments = ["lsp-proxy"];
              path = lib.getExe pkgs.biome;
            };
          };
          nil = {
            binary = {
              path = lib.getExe pkgs.nil;
            };
            initialization_options = {
              formatting = {
                command = [
                  "alejandra"
                  "--quiet"
                  "--"
                ];
              };
            };
          };
        };
      };
    };
  };

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";

    packages = with pkgs; [
      gnomeExtensions.appindicator
      gnomeExtensions.astra-monitor
      gnomeExtensions.bluetooth-battery-meter
      gnomeExtensions.blur-my-shell
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.dash-to-dock
      gnome-tweaks
      gnome-shell-extensions
      gnome-extension-manager
      nautilus
      resources
      _1password-cli
      alejandra
      eza
      ghostty
      nil
      nixd
      ripgrep
      telegram-desktop
      unixtools.xxd
      unzip
      wl-clipboard
      codex
    ];

    sessionVariables = {
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
      TG_DOWNLOAD_DIR = "$HOME/.terragrunt-cache";
      MOZ_ENABLE_WAYLAND = "1";
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
          "Bluetooth-Battery-Meter@maniacx.github.com"
          "blur-my-shell@aunetx"
          "clipboard-indicator@tudmotu.com"
          "dash-to-dock@micxgx.gmail.com"
          "monitor@astraext.github.io"
          "user-theme@gnome-shell-extensions.gcampax.github.com"
        ];
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "adw-gtk3-dark";
        icon-theme = "Tela-dark";
      };

      "org/gnome/desktop/input-sources" = {
        sources = [
          (mkTuple [
            "xkb"
            "us+alt-intl"
          ])
        ];
        xkb-options = ["lv3:switch"]; # Make right ctrl alternate characters key
      };

      "org/gnome/desktop/peripherals/keyboard" = {
        delay = mkUint32 300;
        repeat-interval = mkUint32 20;
      };

      "org/gnome/desktop/peripherals/mouse" = {
        accel-profile = "default";
        speed = -0.5;
      };

      "org/gnome/mutter" = {
        experimental-features = [
          "scale-monitor-framebuffer"
          "variable-refresh-rate"
          "xwayland-native-scaling"
        ];
      };
    };
  };

  imports = [
    ./configs/shell.nix
    ./configs/git.nix
    ./configs/tmux.nix
  ];
}
