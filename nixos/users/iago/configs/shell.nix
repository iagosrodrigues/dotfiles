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
      nrs = "sudo nixos-rebuild switch --flake .#main &| ${lib.getExe pkgs.nix-output-monitor}";
      nrt = "sudo nixos-rebuild test --flake .#main &| ${lib.getExe pkgs.nix-output-monitor}";
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
