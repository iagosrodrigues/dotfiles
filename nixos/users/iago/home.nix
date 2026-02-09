{
  lib,
  hmLib,
  pkgs,
  username,
  inputs,
  ...
}:
with hmLib.hm.gvariant; {
  # Enable Qt theming with dark mode
  qt = {
    enable = true;
    # platformTheme.name = "kde";
    # style.name = "kvantum";
  };

  # Enable GTK theming with dark mode
  gtk = {
    enable = true;
    colorScheme = "dark";

    gtk3.bookmarks = [
      "file:///home/iago/Desktop"
      "file:///home/iago/Documents"
      "file:///home/iago/Downloads"
      "file:///home/iago/Music"
      "file:///home/iago/Pictures"
      "file:///home/iago/Videos"
      "file:///home/iago/Personal"
      "file:///home/iago/Work"
    ];

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

  # Set color scheme preference for applications
  dconf.settings = {
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
        # "scale-monitor-framebuffer"
        # "variable-refresh-rate"
        "xwayland-native-scaling"
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

  programs = {
    home-manager = {
      enable = true;
    };

    niri = {
      settings = {
        prefer-no-csd = false;
        spawn-at-startup = [
          {
            argv = ["ashell"];
          }
          {
            argv = ["ghostty"];
          }
        ];

        input = {
          focus-follows-mouse.max-scroll-amount = "0%";

          keyboard = {
            xkb = {
              layout = "us,us,us";
              variant = "intl,workman-intl,colemak_dh";
              options = "ctrl:nocaps,cap:ctrl_shifted_capslock,grp:win_space_toggle";
            };
            repeat-delay = 250;
            repeat-rate = 40;
            track-layout = "global";
          };

          touchpad = {
            tap = true;
            dwt = true;
          };

          mouse = {
            accel-profile = "flat";
            accel-speed = 0.5;
          };
        };

        layout = {
          gaps = 10;
          center-focused-column = "never";

          default-column-width.proportion = 0.5;
          preset-column-widths = [{proportion = 0.33;} {proportion = 0.5;} {proportion = 0.66;}];
        };

        hotkey-overlay = {
          skip-at-startup = true;
        };

        binds = {
          "Mod+Shift+Slash".action.show-hotkey-overlay = [];

          "Mod+Return".action.spawn = "ghostty";
          "Mod+E".action.spawn = "fuzzel";
          "Mod+B".action.spawn = "firefox";
          "Mod+S".action.spawn = "steam";
          "Mod+T".action.spawn = "telegram";

          "XF86AudioRaiseVolume" = {
            allow-when-locked = true;
            action.spawn = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
          };

          "XF86AudioLowerVolume" = {
            allow-when-locked = true;
            action.spawn = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
          };

          "XF86AudioMute" = {
            allow-when-locked = true;
            action.spawn = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          };

          "XF86AudioMicMute" = {
            allow-when-locked = true;
            action.spawn = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          };

          "XF86AudioPlay" = {
            allow-when-locked = true;
            action.spawn = "playerctl play-pause";
          };

          "Mod+O".action.toggle-overview = [];
          "Mod+Q".action.close-window = [];

          "Mod+Left".action.focus-column-left = [];
          "Mod+Down".action.focus-window-down = [];
          "Mod+Up".action.focus-window-up = [];
          "Mod+Right".action.focus-column-right = [];
          "Mod+H".action.focus-column-left = [];
          # "Mod+J".action.focus-window-down = [];
          # "Mod+K".action.focus-window-up = [];
          "Mod+L".action.focus-column-right = [];

          "Mod+Ctrl+Left".action.move-column-left = [];
          "Mod+Ctrl+Down".action.move-window-down = [];
          "Mod+Ctrl+Up".action.move-window-up = [];
          "Mod+Ctrl+Right".action.move-column-right = [];
          "Mod+Ctrl+H".action.move-column-left = [];
          # "Mod+Ctrl+J".action.move-window-down = [];
          # "Mod+Ctrl+K".action.move-window-up = [];
          # "Mod+Ctrl+L".action.move-column-right = [];

          "Mod+J".action.focus-window-or-workspace-down = [];
          "Mod+K".action.focus-window-or-workspace-up = [];
          "Mod+Ctrl+J".action.move-window-down-or-to-workspace-down = [];
          "Mod+Ctrl+K".action.move-window-up-or-to-workspace-up = [];

          "Mod+Home".action.focus-column-first = [];
          "Mod+End".action.focus-column-last = [];
          "Mod+Ctrl+Home".action.move-column-to-first = [];
          "Mod+Ctrl+End".action.move-column-to-last = [];

          "Mod+Shift+Left".action.focus-monitor-left = [];
          "Mod+Shift+Down".action.focus-monitor-down = [];
          "Mod+Shift+Up".action.focus-monitor-up = [];
          "Mod+Shift+Right".action.focus-monitor-right = [];
          "Mod+Shift+H".action.focus-monitor-left = [];
          "Mod+Shift+J".action.focus-monitor-down = [];
          "Mod+Shift+K".action.focus-monitor-up = [];
          "Mod+Shift+L".action.focus-monitor-right = [];

          "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = [];
          "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = [];
          "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = [];
          "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = [];
          "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = [];
          "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = [];
          "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = [];
          "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = [];

          "Mod+Page_Down".action.focus-workspace-down = [];
          "Mod+Page_Up".action.focus-workspace-up = [];
          "Mod+U".action.focus-workspace-down = [];
          "Mod+I".action.focus-workspace-up = [];
          "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = [];
          "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = [];
          "Mod+Ctrl+U".action.move-column-to-workspace-down = [];
          "Mod+Ctrl+I".action.move-column-to-workspace-up = [];

          "Mod+Shift+Page_Down".action.move-workspace-down = [];
          "Mod+Shift+Page_Up".action.move-workspace-up = [];
          "Mod+Shift+U".action.move-workspace-down = [];
          "Mod+Shift+I".action.move-workspace-up = [];

          "Mod+WheelScrollDown".action.focus-column-right = [];
          "Mod+WheelScrollUp".action.focus-column-left = [];
          "Mod+Ctrl+WheelScrollDown".action.move-column-to-workspace-down = [];
          "Mod+Ctrl+WheelScrollUp".action.move-column-to-workspace-up = [];

          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+6".action.focus-workspace = 6;
          "Mod+7".action.focus-workspace = 7;
          "Mod+8".action.focus-workspace = 8;
          "Mod+9".action.focus-workspace = 9;
          "Mod+Ctrl+1".action.move-column-to-workspace = 1;
          "Mod+Ctrl+2".action.move-column-to-workspace = 2;
          "Mod+Ctrl+3".action.move-column-to-workspace = 3;
          "Mod+Ctrl+4".action.move-column-to-workspace = 4;
          "Mod+Ctrl+5".action.move-column-to-workspace = 5;
          "Mod+Ctrl+6".action.move-column-to-workspace = 6;
          "Mod+Ctrl+7".action.move-column-to-workspace = 7;
          "Mod+Ctrl+8".action.move-column-to-workspace = 8;
          "Mod+Ctrl+9".action.move-column-to-workspace = 9;

          #     Super+Alt+L hotkey-overlay-title="Lock the Screen: swaylock" { spawn "swaylock"; }
          #
          #     XF86AudioStop        allow-when-locked=true { spawn-sh "playerctl stop"; }
          #     XF86AudioPrev        allow-when-locked=true { spawn-sh "playerctl previous"; }
          #     XF86AudioNext        allow-when-locked=true { spawn-sh "playerctl next"; }
          #
          #     XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
          #     XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }
          #
          #     Mod+WheelScrollRight      { focus-column-right; }
          #     Mod+WheelScrollLeft       { focus-column-left; }
          #     Mod+Ctrl+WheelScrollRight { move-column-right; }
          #     Mod+Ctrl+WheelScrollLeft  { move-column-left; }
          #
          #     Mod+Shift+WheelScrollDown      { focus-workspace-down; }
          #     Mod+Shift+WheelScrollUp        { focus-workspace-up; }
          #     Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
          #     Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }
          #
          #     Mod+Tab { focus-workspace-previous; }
          #
          #     Mod+BracketLeft  { consume-or-expel-window-left; }
          #     Mod+BracketRight { consume-or-expel-window-right; }
          #
          #     Mod+Comma  { consume-window-into-column; }
          #     Mod+Period { expel-window-from-column; }
          #
          #     Mod+R { switch-preset-column-width; }
          #     Mod+Shift+R { switch-preset-window-height; }
          #     Mod+Ctrl+R { reset-window-height; }
          "Mod+F".action.maximize-column = [];
          "Mod+Shift+F".action.fullscreen-window = [];
          #
          #     Mod+Ctrl+F { expand-column-to-available-width; }
          #
          #     Mod+C { center-column; }
          #
          #     Mod+Ctrl+C { center-visible-columns; }
          #
          #     Mod+Minus { set-column-width "-10%"; }
          #     Mod+Equal { set-column-width "+10%"; }
          #
          #     Mod+Shift+Minus { set-window-height "-10%"; }
          #     Mod+Shift+Equal { set-window-height "+10%"; }
          #
          #     Mod+V       { toggle-window-floating; }
          #     Mod+Shift+V { switch-focus-between-floating-and-tiling; }
          #
          #     Mod+W { toggle-column-tabbed-display; }
          #
          #     Print { screenshot; }
          #     Ctrl+Print { screenshot-screen; }
          #     Alt+Print { screenshot-window; }
          #
          #     Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
          #
          #     Mod+Shift+E { quit; }
          #     Ctrl+Alt+Delete { quit; }
          #
          #     Mod+Shift+P { power-off-monitors; }
        };

        outputs."DP-1" = {
          focus-at-startup = true;
          mode = {
            width = 2560;
            height = 1440;
            refresh = 74.924;
          };
          backdrop-color = "#001100";
        };

        cursor = {
          size = 48;
          theme = "WhiteSur-cursors";
        };

        # output "eDP-1" {
        #     // off
        #     mode "1920x1080@120.030"
        #     scale 2.0
        #     transform "90"
        #     position x=1280 y=0
        #     variable-refresh-rate // on-demand=true
        #     focus-at-startup
        #     backdrop-color "#001100"

        #     hot-corners {
        #         // off
        #         top-left
        #         // top-right
        #         // bottom-left
        #         // bottom-right
        #     }

        #     layout {
        #         // ...layout settings for eDP-1...
        #     }

        #     // Custom modes. Caution: may damage your display.
        #     // mode custom=true "1920x1080@100"
        #     // modeline 173.00  1920 2048 2248 2576  1080 1083 1088 1120 "-hsync" "+vsync"
        # }
      };
    };

    ashell = {
      enable = true;
      settings = {
        log_level = "error";
        outputs = "All";
        position = "Top";
        app_launcher_cmd = "fuzzel";
        # clipboard_cmd = "wl-co";

        modules = {
          left = [
            "AppLauncher"
            "Workspaces"
            "WindowTitle"
          ];
          center = ["MediaPlayer"];
          right = [
            "Tray"
            "SystemInfo"
            ["Clock" "Clipboard" "Privacy" "Settings"]
          ];
        };

        workspaces = {
          visibility_mode = "All";
          enable_workspace_filling = false;
        };
        system = {
          cpu_warn_threshold = 60;
          cpu_alert_threshold = 80;
          mem_warn_threshold = 70;
          mem_alert_threshold = 85;
          temp_warn_threshold = 60;
          temp_alert_threshold = 80;
        };

        # clock.format = clockFormat;

        # media_player.max_title_length = textCap;

        settings = {
          # lock_cmd = lockCmd;
          # audio_sinks_more_cmd = "${pavucontrol} -t 3";
          # audio_sources_more_cmd = "${pavucontrol} -t 4";
          # wifi_more_cmd = "${terminal} --command=iwctl";
          # vpn_more_cmd = "${terminal} --command=iwctl";
          # bluetooth_more_cmd = "${terminal} --command=bluetoothctl";
        };

        appearance = {
          style = "Islands";
          opacity = 1.0;
        };
      };
    };

    # nvf = {
    #   enable = false;
    #   settings = {
    #     vim = {
    #       lazy.plugins = {
    #         # guess-indent.nvim = {
    #         #   package = pkgs.vimPlugins.guess-indent-nvim;
    #         #   setupModule = "guess-indent.nvim";
    #         # };
    #       };
    #       viAlias = true;
    #       vimAlias = true;
    #       debugMode = {
    #         enable = false;
    #         level = 10;
    #         logFile = "/tmp/nvim.log";
    #       };
    #       spellcheck = {
    #         enable = false;
    #       };
    #       lsp = {
    #         enable = true;
    #         formatOnSave = true;
    #         lspkind.enable = true;
    #         lightbulb.enable = false;
    #         lspsaga.enable = true;
    #         trouble.enable = true;
    #         lspSignature.enable = false;
    #         otter-nvim.enable = true;
    #         nvim-docs-view.enable = true;
    #         harper-ls.enable = true;
    #       };

    #       debugger = {
    #         nvim-dap = {
    #           enable = true;
    #           ui.enable = true;
    #         };
    #       };

    #       languages = {
    #         enableFormat = true;
    #         enableTreesitter = true;
    #         enableExtraDiagnostics = true;

    #         nix.enable = true;
    #         markdown.enable = true;
    #         bash.enable = true;
    #         clang.enable = true;
    #         css.enable = true;
    #         html.enable = true;
    #         json.enable = true;
    #         sql.enable = true;
    #         java.enable = false;
    #         kotlin.enable = false;
    #         ts.enable = true;
    #         go.enable = true;
    #         lua.enable = true;
    #         zig.enable = true;
    #         python.enable = true;
    #         typst.enable = true;
    #         rust = {
    #           enable = true;
    #           extensions.crates-nvim.enable = true;
    #         };
    #       };

    #       visuals = {
    #         nvim-scrollbar.enable = true;
    #         nvim-web-devicons.enable = true;
    #         nvim-cursorline.enable = true;
    #         cinnamon-nvim.enable = true;
    #         fidget-nvim.enable = true;

    #         highlight-undo.enable = true;
    #         indent-blankline.enable = true;

    #         cellular-automaton.enable = true;
    #       };

    #       statusline = {
    #         lualine = {
    #           enable = true;
    #           theme = "catppuccin";
    #         };
    #       };

    #       theme = {
    #         enable = true;
    #         name = "catppuccin";
    #         style = "mocha";
    #         transparent = false;
    #       };

    #       autopairs.nvim-autopairs.enable = true;

    #       autocomplete = {
    #         blink-cmp.enable = true;
    #       };

    #       snippets.luasnip.enable = true;

    #       filetree = {
    #         neo-tree = {
    #           enable = true;
    #         };
    #       };

    #       tabline = {
    #         nvimBufferline.enable = false;
    #       };

    #       treesitter.context.enable = false;

    #       binds = {
    #         whichKey.enable = true;
    #         cheatsheet.enable = true;
    #       };

    #       telescope.enable = true;

    #       git = {
    #         enable = true;
    #         gitsigns.enable = true;
    #         gitsigns.codeActions.enable = false;
    #         neogit.enable = true;
    #       };

    #       minimap = {
    #         minimap-vim.enable = true;
    #         codewindow.enable = true;
    #       };

    #       dashboard = {
    #         dashboard-nvim.enable = false;
    #         alpha.enable = true;
    #       };

    #       notify = {
    #         nvim-notify.enable = true;
    #       };

    #       utility = {
    #         ccc.enable = false;
    #         vim-wakatime.enable = false;
    #         diffview-nvim.enable = true;
    #         yanky-nvim.enable = false;
    #         icon-picker.enable = true;
    #         surround.enable = true;
    #         smart-splits.enable = true;
    #         undotree.enable = true;
    #         nvim-biscuits.enable = false;

    #         motion = {
    #           hop.enable = true;
    #           leap.enable = true;
    #           precognition.enable = false;
    #         };
    #       };

    #       notes = {
    #         neorg.enable = false;
    #         orgmode.enable = false;
    #         mind-nvim.enable = false;
    #         todo-comments.enable = true;
    #       };

    #       terminal = {
    #         toggleterm = {
    #           enable = true;
    #           lazygit.enable = true;
    #         };
    #       };

    #       ui = {
    #         borders.enable = true;
    #         noice.enable = true;
    #         colorizer.enable = true;
    #         modes-nvim.enable = false;
    #         illuminate.enable = true;
    #         breadcrumbs = {
    #           enable = false;
    #           navbuddy.enable = false;
    #         };
    #         smartcolumn = {
    #           enable = true;
    #           setupOpts.custom_colorcolumn = {
    #             nix = "110";
    #             ruby = "120";
    #             java = "130";
    #             go = [
    #               "90"
    #               "130"
    #             ];
    #           };
    #         };
    #         fastaction.enable = true;
    #       };

    #       gestures = {
    #         gesture-nvim.enable = false;
    #       };

    #       comments = {
    #         comment-nvim.enable = true;
    #       };

    #       presence = {
    #         neocord.enable = false;
    #       };

    #       options = {
    #         shiftwidth = 4;
    #         softtabstop = 4;
    #         tabstop = 4;
    #         swapfile = false;
    #         expandtab = true;
    #         smartcase = true;
    #         smartindent = true;
    #         hlsearch = true;
    #         incsearch = true;
    #         ignorecase = true;
    #         autoread = true;
    #       };
    #     };
    #   };
    # };

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
      enable = false;

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
        # buffer_font_family = "0xProto";
        # buffer_font_size = 18;
        vim_mode = true;
        features = {
          edit_prediction_provider = "copilot";
        };
        lsp = {
          tinymist = {
            settings = {
              formatterMode = "typstyle";
            };
          };
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
        font-family = "0xProto";
        font-size = 18;
        theme = "Gruvbox Material";
        command = "/etc/profiles/per-user/iago/bin/fish";
        scrollbar = "system";
        # background-opacity = 0.8;
        # background-blur = 20;
      };
    };
  };

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";

    pointerCursor = {
      gtk.enable = true;
      name = "WhiteSur-cursors";
      package = pkgs.whitesur-cursors;
      size = 48;
    };

    packages = with pkgs; [
      (ffmpeg-full.override {withUnfree = true;})
      (ollama.override {acceleration = "rocm";})
      _1password-cli
      alejandra
      android-tools
      btop
      cargo
      clang
      code-cursor
      codex
      davinci-resolve-studio
      dejavu_fonts
      discord
      eza
      fd
      fuzzel
      gemini-cli
      google-chrome
      google-java-format
      ibm-plex
      inconsolata
      inputs.hytale-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default
      inter
      jetbrains.idea
      jujutsu
      ladybird
      lmstudio
      mongodb-compass
      nil
      nix-output-monitor
      nixd
      opencode
      p7zip
      ripgrep
      rocmPackages.rocm-smi
      statix
      tailscale
      telegram-desktop
      transmission_4-gtk
      unixtools.xxd
      unzip
      wl-clipboard
      xwayland-satellite
    ];

    sessionVariables = {
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };
  };

  fonts.fontconfig.enable = true;

  # stylix.enable = true;

  systemd.user.sessionVariables = {
    EDITOR = "nvim";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    GTK_IM_MODULE = "simple";
    # QT_QPA_PLATFORM = "wayland;xcb";
    # QT_QPA_PLATFORMTHEME = "gnome";
    GSETTINGS_SCHEMA_DIR = "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";
  };
  #
  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [pkgs.xdg-desktop-portal-gnome];
  #   config.common.default = "gnome";
  # };

  imports = [
    ./configs/shell.nix
    ./configs/git.nix
    ./configs/tmux.nix
  ];
}
