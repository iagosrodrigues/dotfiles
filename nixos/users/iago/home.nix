{
  lib,
  hmLib,
  pkgs,
  username,
  ...
}:
with hmLib.hm.gvariant; {
  # Enable Qt theming with dark mode
  qt = {
    enable = true;
    platformTheme.name = "kde";
    style = {
      name = "breeze";
      package = pkgs.kdePackages.breeze;
    };
  };

  # Enable GTK theming with dark mode
  gtk = {
    enable = true;
    colorScheme = "dark";
  };

  # Set color scheme preference for applications
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      force = true;
      color-scheme = "prefer-dark";
    };
  };

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
        vim_mode = false;
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
      _1password-cli
      adwaita-icon-theme
      alejandra
      amp-cli
      # cargo
      clang
      code-cursor
      codex
      eza
      fd
      ghostty
      kdePackages.dolphin
      kdePackages.kate
      kdePackages.konsole
      kdePackages.spectacle
      mongodb-compass
      nil
      nixd
      nodejs
      ripgrep
      # rustc
      telegram-desktop
      unixtools.xxd
      unzip
      wl-clipboard
      zig
      zls
    ];

    sessionVariables = {
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
      TG_DOWNLOAD_DIR = "$HOME/.terragrunt-cache";
      MOZ_ENABLE_WAYLAND = "1";
    };
  };

  imports = [
    ./configs/shell.nix
    ./configs/git.nix
    ./configs/tmux.nix
  ];
}
