{ ... }:
{
  flake.modules.homeManager.ghostty =
    { ... }:
    {
      programs.ghostty = {
        enable = true;
        enableFishIntegration = true;

        settings = {
          font-family = "0xProto";
          font-size = 18;
          theme = "Gruvbox Material";
          command = "/etc/profiles/per-user/iago/bin/fish";
          scrollbar = "system";
        };
      };
    };
}
