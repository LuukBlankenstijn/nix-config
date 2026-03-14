{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [ inputs.zen-browser.homeModules.beta ];

  home.file.".zen".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/zen";

  programs.zen-browser = {
    enable = true;
    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
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
        "browser.tabs.warnOnClose" = false;
        "browser.translations.automaticallyPopup" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "signon.rememberSignons" = false;
        "devtools.toolbox.host" = "right";
      };
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        bitwarden
        multi-account-containers
      ];
      search = {
        force = true;
        default = "ddg";
      };
    };
  };

  wayland.windowManager.hyprland.settings = {
    "$browser" = "${
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    }/bin/zen-beta";

    exec-once = [
      "$browser"
    ];

    windowrule = [
      "match:class zen-beta, workspace 2"
    ];

    bind = [
      "$mainmod, B, exec, $browser"
    ];
  };
}
