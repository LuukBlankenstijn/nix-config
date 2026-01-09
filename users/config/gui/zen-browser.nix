{ inputs, pkgs, ... }:
{
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = {
    enable = true;
    profiles.default = {
      containersForce = true;
      containers = {
        m-account = {
          color = "green";
          icon = "fingerprint";
          id = 1;
        };
        a-account = {
          color = "red";
          icon = "fingerprint";
          id = 2;
        };
      };
      isDefault = true;
      settings = {
        "zen.welcome-screen.seen" = true;
        "zen.theme.hide-unified-extensions-button" = false;
        "zen.updates.show-update-notification" = false;
        browser = {
          tabs.warnOnClose = false;
          download.panel.shown = false;
          translations.automaticallyPopup = false;
        };
      };
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        bitwarden
        multi-account-containers
      ];
      search = {
        force = true;
        default = "qwant";
      };
    };
  };
}
