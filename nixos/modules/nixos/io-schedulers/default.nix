{
  config,
  lib,
  ...
}: let
  cfg = config.local.io-schedulers;
in {
  options.local.io-schedulers.enable = lib.mkEnableOption "Enable I/O scheduler configuration";
  config = lib.mkIf cfg.enable {
    services.udev.extraRules = ''
      # Define 'bfq' para discos rígidos (rotacionais)
      ACTION=="add|change", KERNEL=="sd[a-z][a-z]*", ATTR{queue/rotational}!="0", ATTR{queue/scheduler}="bfq"
      # Define 'mq-deadline' para SSDs SATA e cartões eMMC (não rotacionais)
      ACTION=="add|change", KERNEL=="sd[a-z][a-z]*|mmcblk[0-9][0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
      # Define 'none' para NVMe
      ACTION=="add|change", KERNEL=="nvme[0-9][0-9]*n[0-9][0-9]*", ATTR{queue/scheduler}="none"
    '';
  };
}
