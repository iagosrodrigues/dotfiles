{...}: {
  flake.modules.nixos.fonts = {pkgs, ...}: {
    fonts.packages = with pkgs; [
      _0xproto
      geist-font
      jetbrains-mono
      julia-mono
      maple-mono.variable
      nerd-fonts.symbols-only
      victor-mono
    ];
  };
}
