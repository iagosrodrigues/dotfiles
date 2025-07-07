{
  config,
  pkgs,
  ...
}:
{
  programs.fish = {
    enable = true;
    plugins = [ ];
  };

  programs.mise = {
    enable = true;
  };
}
