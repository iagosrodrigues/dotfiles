{
  lib,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza --icons=always";
      ll = "eza --icons=always -l";
      la = "eza --icons=always -la";
      nrs = "nixos-rebuild --ask-sudo-password switch --flake .#main &| ${lib.getExe pkgs.nix-output-monitor}";
      nrt = "nixos-rebuild --ask-sudo-password test --flake .#main &| ${lib.getExe pkgs.nix-output-monitor}";
    };
    shellAbbrs = {
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
