_: {
  flake.modules.homeManager.browsers =
    { pkgs, ... }:
    {
      programs.brave = {
        enable = true;
      };

      xdg.configFile."autostart/1password.desktop".source =
        "${pkgs._1password-gui}/share/applications/1password.desktop";
    };
}
