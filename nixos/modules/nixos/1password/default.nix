{
  config,
  lib,
  ...
}: let
  cfg = config.local._1password;
in {
  options.local._1password.enable = lib.mkEnableOption "Enable 1Password";
  config = lib.mkIf cfg.enable {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;

      polkitPolicyOwners = ["iago"];
    };
  };
}
