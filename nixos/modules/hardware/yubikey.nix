_: {
  flake.modules.nixos.yubikey =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.local.hardware.yubikey;
    in
    {
      options.local.hardware.yubikey = {
        enable = lib.mkEnableOption "Support for Yubikey devices.";
        pam.enable = lib.mkEnableOption "Enable PAM support for Yubikey devices.";
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
          yubikey-personalization
          yubikey-manager
          yubico-piv-tool
        ];

        security.pam.services = {
          kde.u2fAuth = true;
          su.u2fAuth = true;
          sudo.u2fAuth = true;
        };

        services = {
          pcscd.enable = true;
          udev.packages = [ pkgs.yubikey-personalization ];
        };
      };
    };
}
