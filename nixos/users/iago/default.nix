{pkgs, ...}: {
  isNormalUser = true;
  description = "Iago Sousa Rodrigues";
  extraGroups = [
    "networkmanager"
    "wheel"
    "input"
    "libvirtd"
  ];
  packages = with pkgs; [
    amp-cli
  ];
}
