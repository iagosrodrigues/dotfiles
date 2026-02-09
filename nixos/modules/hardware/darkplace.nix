{ ... }:
{
  flake.modules.nixos.darkplace-hardware =
    {
      lib,
      pkgs,
      modulesPath,
      config,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      # Boot configuration
      boot = {
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
          grub.configurationLimit = 10;
        };

        kernelPackages = pkgs.linuxPackages_latest;

        # LUKS encryption (two encrypted partitions)
        initrd = {
          luks.devices."luks-8a11e66b-0937-4e07-a7b1-5c3101f3c9e3".device =
            "/dev/disk/by-uuid/8a11e66b-0937-4e07-a7b1-5c3101f3c9e3";
          luks.devices."luks-dc16fe29-43f1-4b77-a160-62cfe275333e".device =
            "/dev/disk/by-uuid/dc16fe29-43f1-4b77-a160-62cfe275333e";

          availableKernelModules = [
            "nvme"
            "xhci_pci"
            "ahci"
            "usbhid"
            "usb_storage"
            "sd_mod"
          ];
          kernelModules = [ ];
        };

        kernelModules = [
          "kvm-amd"
          "uvcvideo"
        ];
        extraModulePackages = [ ];
      };

      # Filesystem layout
      fileSystems."/" = {
        device = "/dev/disk/by-uuid/210ed440-0a3a-4efd-bbe7-fc69f136bbcd";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/9B31-E15B";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = [
        { device = "/dev/disk/by-uuid/f20a74c5-75f7-4533-af7e-64f9362a0e55"; }
      ];

      # Networking (DHCP)
      networking.useDHCP = lib.mkDefault true;

      # AMD hardware
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

      # AMD ROCm GPU packages
      hardware.graphics.extraPackages = with pkgs; [
        rocmPackages.clr.icd
        rocmPackages.rocm-runtime
      ];

      system.stateVersion = "25.05";
    };
}
