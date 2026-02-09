{ ... }:
{
  flake.modules.homeManager.zed =
    { lib, pkgs, ... }:
    {
      programs.zed-editor = {
        enable = true;
        extensions = [
          "biome"
          "nix"
          "dockerfile"
          "docker-compose"
        ];
        userSettings = {
          vim_mode = true;
          features = {
            edit_prediction_provider = "copilot";
          };
          lsp = {
            tinymist = {
              settings = {
                formatterMode = "typstyle";
              };
            };
            biome = {
              binary = {
                arguments = [ "lsp-proxy" ];
                path = lib.getExe pkgs.biome;
              };
            };
            nil = {
              binary = {
                path = lib.getExe pkgs.nil;
              };
            };
          };
          terminal = {
            shell = {
              program = "${lib.getExe pkgs.fish}";
            };
          };
        };
        userKeymaps = [
          {
            context = "Editor && edit_prediction_conflict && showing_completions";
            bindings = {
              tab = "editor::AcceptEditPrediction";
            };
          }
        ];
      };
    };
}
