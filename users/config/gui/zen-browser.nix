{
  osConfig,
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  addonsPkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfreePredicate =
      pkg: builtins.elem (lib.getName pkg) [ "onepassword-password-manager" ];
    overlays = [ inputs.firefox-addons.overlays.default ];
  };
  addons = addonsPkgs.firefox-addons;
in
{
  imports = [ inputs.zen-browser.homeModules.beta ];

  config =
    lib.mkIf (osConfig.cfg.userConfig.desktop.enable && osConfig.cfg.userConfig.desktop.browser.enable)
      (
        lib.mkMerge [
          {
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
                  work = {
                    color = "blue";
                    icon = "fingerprint";
                    id = 3;
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
                extensions.packages = [
                  addons.bitwarden
                  addons.multi-account-containers
                  addons.onepassword-password-manager
                ];
                search = {
                  force = true;
                  default = "ddg";
                };
              };
            };

          }

          (lib.mkIf osConfig.cfg.userConfig.desktop.hyprland.enable {
            wayland.windowManager.hyprland.settings = {
              "$browser" = "${
                inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
              }/bin/zen-beta";

              exec-once = [ "$browser" ];

              windowrule = [
                "match:class zen-beta, workspace 2"
              ];

              bind = [
                "$mainmod, B, exec, $browser"
              ];
            };
          })
        ]
      );
}
