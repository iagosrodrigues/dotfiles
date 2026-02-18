_: {
  flake.modules.nixos.nix-settings = {
    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];
        auto-optimise-store = true;
        warn-dirty = false;
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };

      optimise.automatic = true;
    };

    programs.nix-ld.enable = true;
  };
}
