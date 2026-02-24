_: {
  flake.modules.nixos.virtualisation =
    { pkgs, ... }:
    {
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
}
