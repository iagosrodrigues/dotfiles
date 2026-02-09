{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.gaming;
in {
  options.local.gaming = {
    enable = lib.mkEnableOption "Enable Gaming";

    settings = {
      hdr.enable = lib.mkEnableOption "Enable High Definition Range (HDR) support";
      rt = {
        enable = lib.mkEnableOption "Enable soft realtime priority (RT) support";
        optimize = lib.mkOption {
          type = lib.types.bool;
          default = cfg.settings.rt.enable;
          defaultText = lib.literalExpression "config.local.gaming.settings.rt.enable";
          description = "Enable kernel optimizations for soft RT";
        };
      };
      vrr.enable = lib.mkEnableOption "Enable Variable Refresh Rate (VRR) support";
      mangohud = {
        enable = lib.mkEnableOption "Enable MangoHud configuration";
        configStr = lib.mkOption {
          type = lib.types.str;
          default = "full,core_load=0";
          description = "Mangohud config flags";
        };
      };
      vkbasalt.enable = lib.mkEnableOption "Enable vkBasalt configuration";
      ntsync.enable = lib.mkEnableOption "Enable usage ntsync configuration"; # TODO add ntsync enablement in the config if possible
      wow64.enable = lib.mkEnableOption "Enable usage wow64 configuration"; # sometimes needed when using ntsync in 32 bit games
      wayland.enable = lib.mkEnableOption "Enable proton wayland support";
    };
    steam = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Enable steam configuration";
      };
      extraEnv = lib.mkOption {
        type = lib.types.nullOr lib.types.attrs;
        default = {
          MANGOHUD = cfg.settings.mangohud.enable;
          MANGOHUD_CONFIG = cfg.settings.mangohud.configStr;
          ENABLE_VKBASALT = cfg.settings.vkbasalt.enable;
          PROTON_USE_NTSYNC = cfg.settings.ntsync.enable;
          PROTON_USE_WOW64 = cfg.settings.wow64.enable;
          PROTON_ENABLE_HDR = cfg.settings.hdr.enable;
          PROTON_ENABLE_WAYLAND = cfg.settings.wayland.enable;
          PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES = true; # temp
        };
        description = lib.literalExpression "Env vars to insert into steam package environment";
      };
      # compatPackages = lib.mkOption {
      #   type = lib.types.listOf lib.types.package;
      #   default = [ pkgs.proton-experimental ];
      #   description = lib.literalExpression "List of extra compatibility packages like proton-ge";
      # };
    };
    gamemode = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Enable gamemode configuration";
      };
      enableNotifications = lib.mkEnableOption "Enable notifications on the startup and end of execution";
    };
    wivrn = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Enable wivrn configuration";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      (lib.optionals cfg.settings.mangohud.enable [pkgs.mangohud])
      ++ (lib.optionals cfg.settings.hdr.enable [pkgs.gamescope-wsi])
      ++ (lib.optionals cfg.settings.vkbasalt.enable [pkgs.vkbasalt])
      ++ [
        pkgs.ffmpeg-full
        pkgs.libva-utils
        pkgs.vdpauinfo
      ];

    systemd.tmpfiles.rules = lib.mkIf cfg.settings.rt.enable [
      "w /proc/sys/kernel/sched_autogroup_enabled - - - - 1"
      "w /proc/sys/kernel/sched_cfs_bandwidth_slice_us - - - - 3000"
      "w /proc/sys/kernel/sched_child_runs_first - - - - 0"
      "w /proc/sys/vm/compaction_proactiveness - - - - 0"
      "w /proc/sys/vm/min_free_kbytes - - - - 1048576"
      "w /proc/sys/vm/page_lock_unfairness - - - - 1"
      "w /proc/sys/vm/swappiness - - - - 10"
      "w /proc/sys/vm/watermark_boost_factor - - - - 1"
      "w /proc/sys/vm/watermark_scale_factor - - - - 500"
      "w /proc/sys/vm/zone_reclaim_mode - - - - 0"
      "w /sys/kernel/debug/sched/base_slice_ns  - - - - 3000000"
      "w /sys/kernel/debug/sched/migration_cost_ns - - - - 500000"
      "w /sys/kernel/debug/sched/nr_migrate - - - - 8"
      "w /sys/kernel/mm/lru_gen/enabled - - - - 5"
      "w /sys/kernel/mm/transparent_hugepage/defrag - - - - never"
      "w /sys/kernel/mm/transparent_hugepage/enabled - - - - madvise"
      "w /sys/kernel/mm/transparent_hugepage/shmem_enabled - - - - advise"
    ];

    fileSystems."/home/iago/.local/share/Steam/Downloads" = {
      device = "/home/iago/Downloads";
      options = ["bind" "nofail"];
    };

    programs.steam = lib.mkIf cfg.steam.enable {
      enable = lib.mkDefault true;
      package = pkgs.steam.override {
        extraEnv = cfg.steam.extraEnv;
      };
      remotePlay.openFirewall = lib.mkDefault true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = lib.mkDefault true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = lib.mkDefault true;
      gamescopeSession.enable = lib.mkDefault false;
      protontricks.enable = lib.mkDefault true;
      extraCompatPackages = [pkgs.proton-ge-bin];
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libva
        rocmPackages.clr.icd
      ];
    };

    programs.gamemode = {
      enable = lib.mkDefault true;
      enableRenice = lib.mkDefault true;
      settings = {
        # TODO change to be more lib-y
        general = {
          desiredgov = "performance";
          reaper_freq = 3;
          renice = 4;
          softrealtime = "on";
          inhibit_screensaver = 1;
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          amd_performance_level = "high";
        };
        cpu = {
          park_cores = "no";
          pin_cores = "yes";
        };
        custom = lib.mkIf cfg.gamemode.enableNotifications {
          start = lib.mkDefault "${pkgs.libnotify}/bin/notify-send 'GameMode Started'";
          end = lib.mkDefault "${pkgs.libnotify}/bin/notify-send 'GameMode Ended'";
        };
      };
    };

    programs.envision = {
      enable = true;
      openFirewall = true;
    };

    services.wivrn = lib.mkIf cfg.wivrn.enable {
      enable = true;
      openFirewall = true;
      defaultRuntime = true;
      autoStart = true;
    };
  };
}
