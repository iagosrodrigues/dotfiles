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
        # shell = pkgs.fish;
      };

      home-manager.users.${username} =
        { pkgs, ... }:
        {
          programs.home-manager.enable = true;

          programs.brave.enable = true;
          programs.mpv.enable = true;
          programs.tmux.enable = true;
          programs.fish.enable = true;

          home = {
            inherit username;
            homeDirectory = "/home/${username}";
            stateVersion = "25.05";

            pointerCursor = {
              gtk.enable = true;
              name = "macOS";
              package = pkgs.apple-cursor;
              size = 48;
            };

            packages = with pkgs; [
              # (ollama.override { acceleration = "rocm"; })
              # codex
              # gemini-cli
              # google-chrome
              # google-java-format
              # ladybird
              # mongodb-compass
              # nix-output-monitor
              # rocmPackages.rocm-smi
              # xwayland-satellite
              _1password-cli
              android-tools
              btop
              cargo
              clang
              davinci-resolve-studio
              discord
              eza
              fd
              ffmpeg
              fuzzel
              # inputs.hytale-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default
              jetbrains.idea
              jujutsu
              libreoffice-still
              lmstudio
              nil
              nixd
              nixfmt
              nodejs
              opencode
              p7zip
              ripgrep
              statix
              telegram-desktop
              transmission_4-gtk
              unixtools.xxd
              unzip
              wl-clipboard
            ];

            sessionVariables = {
              EDITOR = "nvim";
              # Wayland compatibility
              NIXOS_OZONE_WL = "1";
              MOZ_ENABLE_WAYLAND = "1";
              QT_QPA_PLATFORM = "wayland";
              SDL_VIDEODRIVER = "wayland";
              GDK_BACKEND = "wayland";
              GTK_IM_MODULE = "simple";
              QT_IM_MODULE = "simple";
            };
          };

          fonts.fontconfig.enable = true;

          systemd.user.sessionVariables = {
            EDITOR = "nvim";
          };
        };
    };
}
