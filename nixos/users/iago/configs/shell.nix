{...}: {
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza --icons=always";
      ll = "eza --icons=always -l";
      la = "eza --icons=always -la";
    };
  };

  programs.mise = {
    enable = true;
  };

  programs.starship = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
  };
}
