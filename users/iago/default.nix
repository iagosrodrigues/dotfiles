{pkgs, ...}: {
  isNormalUser = true;
  description = "iago";
  extraGroups = ["networkmanager" "wheel" "libvirtd"];
  packages = with pkgs; [
    kdePackages.kate
  ];
}
