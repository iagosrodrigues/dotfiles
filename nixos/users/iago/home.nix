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
    # platformTheme.name = "kde";
    style.name = "kvantum";
  };

  # Enable GTK theming with dark mode
  gtk = {
    enable = true;
    gtk2.force = true;
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

    nvf = {
      enable = true;
      settings = {
        vim = {
          lazy.plugins = {
            # guess-indent.nvim = {
            #   package = pkgs.vimPlugins.guess-indent-nvim;
            #   setupModule = "guess-indent.nvim";
            # };
          };
          viAlias = true;
          vimAlias = true;
          debugMode = {
            enable = false;
            level = 10;
            logFile = "/tmp/nvim.log";
          };
          spellcheck = {
            enable = false;
          };
          lsp = {
            enable = true;
            formatOnSave = true;
            lspkind.enable = true;
            lightbulb.enable = false;
            lspsaga.enable = true;
            trouble.enable = true;
            lspSignature.enable = false;
            otter-nvim.enable = true;
            nvim-docs-view.enable = true;
            harper-ls.enable = true;
          };

          debugger = {
            nvim-dap = {
              enable = true;
              ui.enable = true;
            };
          };

          languages = {
            enableFormat = true;
            enableTreesitter = true;
            enableExtraDiagnostics = true;

            nix.enable = true;
            markdown.enable = true;
            bash.enable = true;
            clang.enable = true;
            css.enable = true;
            html.enable = true;
            json.enable = true;
            sql.enable = true;
            java.enable = false;
            kotlin.enable = false;
            ts.enable = true;
            go.enable = true;
            lua.enable = true;
            zig.enable = true;
            python.enable = true;
            typst.enable = true;
            rust = {
              enable = true;
              extensions.crates-nvim.enable = true;
            };
          };

          visuals = {
            nvim-scrollbar.enable = true;
            nvim-web-devicons.enable = true;
            nvim-cursorline.enable = true;
            cinnamon-nvim.enable = true;
            fidget-nvim.enable = true;

            highlight-undo.enable = true;
            indent-blankline.enable = true;

            cellular-automaton.enable = true;
          };

          statusline = {
            lualine = {
              enable = true;
              theme = "catppuccin";
            };
          };

          theme = {
            enable = true;
            name = "catppuccin";
            style = "mocha";
            transparent = false;
          };

          autopairs.nvim-autopairs.enable = true;

          autocomplete = {
            blink-cmp.enable = true;
          };

          snippets.luasnip.enable = true;

          filetree = {
            neo-tree = {
              enable = true;
            };
          };

          tabline = {
            nvimBufferline.enable = false;
          };

          treesitter.context.enable = false;

          binds = {
            whichKey.enable = true;
            cheatsheet.enable = true;
          };

          telescope.enable = true;

          git = {
            enable = true;
            gitsigns.enable = true;
            gitsigns.codeActions.enable = false;
            neogit.enable = true;
          };

          minimap = {
            minimap-vim.enable = true;
            codewindow.enable = true;
          };

          dashboard = {
            dashboard-nvim.enable = false;
            alpha.enable = true;
          };

          notify = {
            nvim-notify.enable = true;
          };

          utility = {
            ccc.enable = false;
            vim-wakatime.enable = false;
            diffview-nvim.enable = true;
            yanky-nvim.enable = false;
            icon-picker.enable = true;
            surround.enable = true;
            smart-splits.enable = true;
            undotree.enable = true;
            nvim-biscuits.enable = false;

            motion = {
              hop.enable = true;
              leap.enable = true;
              precognition.enable = false;
            };
          };

          notes = {
            neorg.enable = false;
            orgmode.enable = false;
            mind-nvim.enable = false;
            todo-comments.enable = true;
          };

          terminal = {
            toggleterm = {
              enable = true;
              lazygit.enable = true;
            };
          };

          ui = {
            borders.enable = true;
            noice.enable = true;
            colorizer.enable = true;
            modes-nvim.enable = false;
            illuminate.enable = true;
            breadcrumbs = {
              enable = false;
              navbuddy.enable = false;
            };
            smartcolumn = {
              enable = true;
              setupOpts.custom_colorcolumn = {
                nix = "110";
                ruby = "120";
                java = "130";
                go = [
                  "90"
                  "130"
                ];
              };
            };
            fastaction.enable = true;
          };

          gestures = {
            gesture-nvim.enable = false;
          };

          comments = {
            comment-nvim.enable = true;
          };

          presence = {
            neocord.enable = false;
          };

          options = {
            shiftwidth = 4;
            softtabstop = 4;
            tabstop = 4;
            swapfile = false;
            expandtab = true;
            smartcase = true;
            smartindent = true;
            hlsearch = true;
            incsearch = true;
            ignorecase = true;
            autoread = true;
          };
        };
      };
    };

    mpv.enable = true;

    direnv = {
      enable = true;
      mise.enable = true;
      nix-direnv.enable = true;
    };

    brave = {
      enable = true;
      # extensions = {
      #   packages = with pkgs.nur.repos.rycee.brave-addons; [
      #     onepassword-password-manager
      #     ublock-origin
      #     privacy-badger
      #   ];
      # };
    };

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
        buffer_font_family = ".ZedMono";
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
        terminal = {
          shell = {
            program = "${lib.getExe pkgs.fish}";
          };
        };
      };
      userKeymaps = [
        {
          context = "Editor && edit_prediction_conflict && showing_completions";
          bindings = {
            tab = "editor::AcceptEditPrediction";
          };
        }
      ];
    };

    ghostty = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        font-family = "Julia Mono";
        font-size = 18;
        theme = "Gruvbox Material";
        command = "/etc/profiles/per-user/iago/bin/fish";
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
      btop
      cargo
      clang
      clippy
      code-cursor
      codex
      eza
      fd
      google-java-format
      jetbrains.idea
      kdePackages.dolphin
      kdePackages.kate
      kdePackages.kcalc
      kdePackages.konsole
      kdePackages.spectacle
      ladybird
      mongodb-compass
      nil
      nix-output-monitor
      nixd
      nodejs
      ripgrep
      rustc
      rustfmt
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
      MOZ_ENABLE_WAYLAND = "1";
    };
  };

  systemd.user.sessionVariables = {
    GTK_IM_MODULE = "simple";
  };

  imports = [
    ./configs/shell.nix
    ./configs/git.nix
    ./configs/tmux.nix
  ];
}
