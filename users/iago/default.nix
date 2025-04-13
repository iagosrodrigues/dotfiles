{pkgs, ...}: {
  isNormalUser = true;
  description = "iago";
  extraGroups = ["networkmanager" "wheel"];
  packages = with pkgs; [
    kdePackages.kate
  ];
}
