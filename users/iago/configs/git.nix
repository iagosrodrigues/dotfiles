{
  config,
  pkgs,
  ...
}: let
  onePassPath = "~/.1password/agent.sock";
in {
  programs.git = {
    enable = true;
    userName = "Iago S. Rodrigues";
    userEmail = "me@iagosousa.com";
    signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA+9boyw9MLSLia/aW9DQFD4NLpMc6mlG81FpIwSdkcu";
    aliases = {
      br = "branch";
      ci = "commit";
      cl = "clone";
      co = "switch";
      cob = "switch -c";
      cp = "cherry-pick";
      cs = "commit -S";
      gr = "grep -Ii";
      r = "reset";
      s = "status -s";
      ss = "status";
    };
  };
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        IdentityAgent ${onePassPath}
    '';
  };
}
