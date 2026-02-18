_: {
  flake.modules.nixos.virtualisation =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.local.system.virtualisation;
    in
    {
      options.local.system.virtualisation.enable =
        lib.mkEnableOption "Virtualisation support (libvirt, Docker)";

      config = lib.mkIf cfg.enable {
        virtualisation = {
          libvirtd = {
            enable = true;
            qemu = {
              swtpm.enable = true;
            };
          };

          spiceUSBRedirection.enable = true;

          docker = {
            enable = true;
            enableOnBoot = false;
          };
        };

        environment.systemPackages = with pkgs; [
          virt-manager
        ];
      };
    };
}
