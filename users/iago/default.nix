{ pkgs, ... }:
{
  isNormalUser = true;
  description = "iago";
  extraGroups = [
    "networkmanager"
    "wheel"
    "input"
    "libvirtd"
  ];
  packages = with pkgs; [
    kdePackages.kate
  ];
}
