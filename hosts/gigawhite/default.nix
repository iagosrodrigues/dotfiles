{
  inputs,
  hostname,
}: {
  system = "x86_64-linux";
  modules = [
    # inputs.chaotic.nixosModules.default
    # inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.impermanence
    inputs.lanzaboote.nixosModules.lanzaboote
  ];
}
