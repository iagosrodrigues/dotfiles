{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
  hm = config.flake.modules.homeManager;

  sharedNixosModules = with nixos; [
    audio
    fonts
    gamemode
    gaming-graphics
    gnome
    home-manager-base
    iago
    io-schedulers
    lact
    networking
    niri
    nix-settings
    nixpkgs-config
    onepassword
    private
    shell
    sops
    steam
    virtualisation
    vr
    yubikey
  ];

  sharedHmModules = with hm; [
    ashell
    browsers
    dark-theme
    dev-tools
    ghostty
    git
    gnome
    media
    niri
    niri-config
    private
    shell
    tmux
    zed
  ];

  nixosModules = sharedNixosModules ++ [
    nixos.darkplace-hardware
    nixos.darkplace-features
  ];

  hmModules = sharedHmModules ++ [
    hm.darkplace-features
  ];
in
{
  flake.nixosConfigurations.darkplace = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = nixosModules ++ [ { home-manager.sharedModules = hmModules; } ];
  };
}
