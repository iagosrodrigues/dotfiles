{
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

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";

    packages = with pkgs; [
      _1password-cli
      _1password-gui
      alejandra
      clang
      direnv
      discord
      eza
      fnm
      ghostty
      go
      kitty
      nil
      nixd
      nodejs_22
      poetry
      stow
      telegram-desktop
      tmux
      unixtools.xxd
      unzip
      wl-clipboard
      wofi
      xsel
      zed-editor
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
