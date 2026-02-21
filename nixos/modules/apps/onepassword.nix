_: {
  flake.modules.nixos.onepassword =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.local.apps.onepassword;
    in
    {
      options.local.apps.onepassword.enable = lib.mkEnableOption "1Password password manager";

      config = lib.mkIf cfg.enable {
        programs._1password.enable = true;
        programs._1password-gui = {
          enable = true;
          polkitPolicyOwners = [ "iago" ];
        };
      };
    };
}
