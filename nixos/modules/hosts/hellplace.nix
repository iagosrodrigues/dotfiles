{
  inputs,
  config,
  ...
}:
let
  nixos = config.flake.modules.nixos;
  hm = config.flake.modules.homeManager;

  sharedNixosModules = with nixos; [
    audio
    fonts
    gnome
    home-manager-base
    iago
    io-schedulers
    networking
    niri
    nix-settings
    nixpkgs-config
    onepassword
    printing
    private
    shell
    sops
    steam
    tailscale
    virtualisation
    vr
    yubikey
  ];

  sharedHmModules = with hm; [
    ashell
    dev-tools
    ghostty
    git
    gnome
    niri
    niri-config
    private
    shell
    steam
    tailscale
    zed
  ];

  diskoConfig = import ../../disko/hellplace.nix;

  nixosModules = sharedNixosModules ++ [
    nixos.hellplace-hardware
    inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.impermanence
    diskoConfig
    {
      networking.hostName = "hellplace";

      fileSystems."/persist".neededForBoot = true;

      # Declarative password management (impermanence wipes /etc/shadow)
      users.mutableUsers = false;
      users.users.iago.hashedPasswordFile = "/persist/secrets/iago-password";

      environment.persistence."/persist" = {
        hideMounts = true;
        directories = [
          # Core system state
          "/var/log"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"

          # Network
          "/var/lib/NetworkManager"
          "/etc/NetworkManager/system-connections"

          # Virtualisation
          "/var/lib/docker"
          "/var/lib/libvirt"

          # Services
          "/var/lib/cups"
          "/var/lib/AccountsService"

          # Audio (persistent volume levels)
          "/var/lib/pipewire"
        ];
        files = [
          "/etc/machine-id"
          "/etc/adjtime"

          # SSH host keys (prevent fingerprint change on reboot)
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
        ];
      };
    }
  ];

  hmModules = sharedHmModules ++ [
    {
      home.persistence."/persist" = {
        directories = [
          # User data
          "Downloads"
          "Projects"

          # Application state
          ".local/share/TelegramDesktop"
          ".local/share/direnv"
          ".local/share/fish"
          ".local/share/keyrings"
          ".local/share/nix"
          ".local/share/opencode"
          ".local/state/wireplumber"

          # Application config
          ".config/1Password"
          ".config/BraveSoftware"
          ".config/dconf"
          ".config/discord"
          ".config/libvirt"
          ".config/obs-studio"
          ".config/opencode"

          # Cache Vulkan shaders
          ".cache/mesa_shader_cache"

          # Crypto / Auth
          ".gnupg"
          ".ssh"

          # AI / ML
          ".ollama"
          ".lmstudio"
          ".config/LM Studio"
        ];
      };
    }
  ];
in
{
  flake.nixosConfigurations.hellplace = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = nixosModules ++ [ { home-manager.sharedModules = hmModules; } ];
  };
}
