{ inputs, ... }:
{
  flake.modules.homeManager.kde-dark =
    { pkgs, ... }:
    {
      imports = [ inputs.plasma-manager.homeModules.plasma-manager ];
      # programs.plasma.kwin.decoration = {
      #   style = "breeze-dark";
      #   colorScheme = "Breeze-Dark";
      # };

      # home.pointerCursor = {
      #   gtk.enable = true;
      #   name = "macOS";
      #   package = pkgs.apple-cursor;
      #   size = 48;
      # };
    };
}
