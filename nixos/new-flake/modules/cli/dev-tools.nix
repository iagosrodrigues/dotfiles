{...}: {
  flake.modules.homeManager.dev-tools = {...}: {
    programs.direnv = {
      enable = true;
      mise.enable = true;
      nix-direnv.enable = true;
    };

    programs.mise.enable = true;
  };
}
