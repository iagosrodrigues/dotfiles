{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
  cfg = config.local.impermanence;
in {
  options.local.impermanence = {
    enable = mkEnableOption "Stateless system support via impermanence.";

    root = mkOption {
      type = types.str;
      default = "/persist";
      description = "Mount point that stores persistent state.";
      example = "/persist";
    };

    directories = mkOption {
      type = types.listOf types.str;
      default = [
        "/etc/nixos"
        "/etc/NetworkManager/system-connections"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd"
        "/var/log"
      ];
      description = "Absolute directories persisted across reboots.";
    };

    files = mkOption {
      type = types.listOf types.str;
      default = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
      description = "Absolute files persisted across reboots.";
    };

    users = mkOption {
      type = types.attrsOf (
        types.submodule ({options, ...}: {
          options.directories = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "User directories (relative to the home) to persist.";
          };
          options.files = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "User files (relative to the home) to persist.";
          };
        })
      );
      default = {};
      description = ''
        User specific persistence configuration. Attribute names map to usernames
        under environment.persistence.<root>.users.
      '';
    };

    extraConfig = mkOption {
      type = types.attrs;
      default = {};
      description = "Additional attrs merged into environment.persistence.<root>.";
    };
  };

  config = mkIf cfg.enable {
    imports = [inputs.impermanence.nixosModules.impermanence];

    environment.persistence.${cfg.root} = mkMerge [
      cfg.extraConfig
      {
        directories = cfg.directories;
        files = cfg.files;
        users = cfg.users;
      }
    ];
  };
}
