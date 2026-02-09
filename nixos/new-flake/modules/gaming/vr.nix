{...}: {
  flake.modules.nixos.vr = {
    programs.envision = {
      enable = true;
      openFirewall = true;
    };

    services.wivrn = {
      enable = true;
      openFirewall = true;
      defaultRuntime = true;
      autoStart = true;
    };
  };
}
