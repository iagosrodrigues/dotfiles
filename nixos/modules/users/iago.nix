{ inputs, ... }:
let
  username = "iago";
in
{
  flake.modules.nixos.${username} =
    { pkgs, ... }:
    {
      users.users.${username} = {
        isNormalUser = true;
        description = "Iago Sousa Rodrigues";
        extraGroups = [
          "adbusers"
          "docker"
          "input"
          "libvirtd"
          "networkmanager"
          "render"
          "video"
          "wheel"
        ];
        shell = pkgs.fish;
      };

      home-manager.users.${username} =
        { pkgs, ... }:
        {
          programs.home-manager.enable = true;

          home = {
            inherit username;
            homeDirectory = "/home/${username}";
            stateVersion = "25.05";

            packages = with pkgs; [
              (ollama.override { acceleration = "rocm"; })
              _1password-cli
              android-tools
              btop
              cargo
              clang
              codex
              davinci-resolve-studio
              discord
              eza
              fd
              ffmpeg
              fuzzel
              gemini-cli
              google-chrome
              google-java-format
              inputs.hytale-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default
              jetbrains.idea
              jujutsu
              ladybird
              lmstudio
              mongodb-compass
              nil
              nix-output-monitor
              nixd
              nixfmt
              nodejs
              opencode
              p7zip
              ripgrep
              rocmPackages.rocm-smi
              statix
              tailscale
              telegram-desktop
              transmission_4-gtk
              unixtools.xxd
              unzip
              wl-clipboard
              xwayland-satellite
            ];

            sessionVariables = {
              EDITOR = "nvim";
              NIXOS_OZONE_WL = "1";
              MOZ_ENABLE_WAYLAND = "1";
              GTK_IM_MODULE = "simple";
              QT_IM_MODULE = "simple";
            };
          };

          fonts.fontconfig.enable = true;

          systemd.user.sessionVariables = {
            EDITOR = "nvim";
            MOZ_ENABLE_WAYLAND = "1";
            NIXOS_OZONE_WL = "1";
          };
        };
    };
}
