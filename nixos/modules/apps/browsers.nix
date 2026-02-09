{ ... }:
{
  flake.modules.homeManager.browsers =
    { ... }:
    {
      programs.brave = {
        enable = true;
      };
    };
}
