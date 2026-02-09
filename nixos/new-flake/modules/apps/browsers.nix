{...}: {
  # NixOS side: firefox program
  flake.modules.nixos.browsers = {
    programs.firefox.enable = true;
  };

  # Home-manager side: brave + firefox profile config
  flake.modules.homeManager.browsers = {pkgs, ...}: {
    programs.brave = {
      enable = true;
    };

    programs.firefox = {
      enable = false;

      profiles.default = {
        isDefault = true;

        settings = {
          "signon.rememberSignons" = false;
          "signon.autofillForms" = false;
          "signon.formlessCapture.enabled" = false;

          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "extensions.formautofill.heuristics.enabled" = false;

          "places.history.enabled" = false;
          "browser.formfill.enable" = false;
          "browser.urlbar.suggest.bookmark" = false;
          "browser.urlbar.suggest.history" = false;
          "browser.urlbar.suggest.openpage" = false;
          "browser.urlbar.suggest.topsites" = false;

          "browser.download.useDownloadDir" = false;
          "browser.cache.disk.enable" = false;
          "browser.cache.memory.enable" = true;

          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "identity.fxaccounts.enabled" = false;

          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "extensions.pocket.enabled" = false;
        };

        extensions = {
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            onepassword-password-manager
            ublock-origin
            privacy-badger
          ];
        };
      };
    };
  };
}
