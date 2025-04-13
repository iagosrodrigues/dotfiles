{
  pkgs,
  username,
  ...
}: {
  programs = {
    home-manager = {
      enable = true;
    };
  };

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";

    packages = with pkgs; [
      tmux
      _1password-gui
      ghostty
      telegram-desktop
      xsel
      wl-clipboard
      eza
      stow
      clang
      zig
      unzip
      go
      unixtools.xxd
      direnv
      discord
      zed-editor
      nixd
      # netskope-client
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  imports = [
    ./configs/shell.nix
    # ./neovim.nix
    ./configs/git.nix
    ./configs/tmux.nix
  ];
}
