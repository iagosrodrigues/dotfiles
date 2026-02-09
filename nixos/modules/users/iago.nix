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
              code-cursor
              codex
              davinci-resolve-studio
              dejavu_fonts
              discord
              eza
              fd
              ffmpeg
              fuzzel
              gemini-cli
              google-chrome
              google-java-format
              ibm-plex
              inconsolata
              inputs.hytale-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default
              inter
              jetbrains.idea
              jujutsu
              ladybird
              lmstudio
              mongodb-compass
              nil
              nix-output-monitor
              nixd
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
            };
          };

          fonts.fontconfig.enable = true;

          systemd.user.sessionVariables = {
            EDITOR = "nvim";
            MOZ_ENABLE_WAYLAND = "1";
            NIXOS_OZONE_WL = "1";
            GTK_IM_MODULE = "cedilla";
            QT_IM_MODULE = "cedilla";
            GSETTINGS_SCHEMA_DIR = "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";
          };
        };
    };
}
