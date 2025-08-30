{
  lib,
  pkgs,
  username,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  programs = {
    home-manager = {
      enable = true;
    };
    mpv.enable = true;
    firefox = {
      enable = true;
      # preferences = {
      #   "widget.use-xdg-desktop-portal.file-picker" = 1;
      # };
    };
  };

  programs.zed-editor = {
    enable = true;
    extensions = [
      "biome"
    ];
    userSettings = {
      lsp = {
        biome = {
          binary = {
            arguments = [ "lsp-proxy" ];
            path = lib.getExe pkgs.biome;
          };
        };
      };
    };
  };

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";

    packages = with pkgs; [
      _1password-cli
      alejandra
      biome
      clang
      discord
      electrum
      eza
      fnm
      ghostty
      glib
      go
      kitty
      nil
      nixd
      nodejs_22
      poetry
      ripgrep
      stow
      telegram-desktop
      tmux
      unixtools.xxd
      unzip
      wl-clipboard
      wofi
      xsel
      zig
      # netskope-client
    ];

    sessionVariables = {
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
    };
  };

  imports = [
    ./configs/shell.nix
    # ./neovim.nix
    ./configs/git.nix
    ./configs/tmux.nix
  ];
}
