_: {
  # NixOS side: enable fish as a system shell
  flake.modules.nixos.shell =
    { pkgs, ... }:
    {
      programs.fish.enable = true;
      environment.systemPackages = [ pkgs.neovim ];
    };

  # Home-manager side: fish config, starship, zoxide
  flake.modules.homeManager.shell =
    { lib, pkgs, ... }:
    {
      programs = {
        fish = {
          enable = true;
          shellAliases = {
            ls = "eza --icons=always";
            ll = "eza --icons=always -l";
            la = "eza --icons=always -la";
            nrs = "sudo nixos-rebuild switch --flake .#(hostname) &| ${lib.getExe pkgs.nix-output-monitor}";
            nrt = "sudo nixos-rebuild test --flake .#(hostname) &| ${lib.getExe pkgs.nix-output-monitor}";
          };
        };

        starship.enable = true;

        zoxide.enable = true;
      };
    };
}
