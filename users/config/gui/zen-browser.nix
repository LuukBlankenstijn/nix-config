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
  browserCfg = osConfig.cfg.userConfig.desktop.browser;
  addonsPkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) browserCfg.extensions;
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
                containers = browserCfg.containers;
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
                extensions.packages = map (name: addons.${name}) browserCfg.extensions;
                search = {
                  force = true;
                  default = "ddg";
                };
              };
            };

            desktop.binds.browser = {
              key = "B";
              command = [
                "${inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/zen-beta"
              ];
            };

            desktop.pinnedApps.browser = {
              command = [
                "${inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/zen-beta"
              ];
              appId = "zen-beta";
              workspace = "web";
              columnWidth = 1.0;
            };
          }

          (lib.mkIf osConfig.cfg.userConfig.desktop.hyprland.enable {
            wayland.windowManager.hyprland.settings = {
              browser = {
                _var = "${inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/zen-beta";
              };

              on = [
                {
                  _args = [
                    "hyprland.start"
                    (lib.generators.mkLuaInline ''
                      function()
                        hl.exec_cmd(browser)
                      end
                    '')
                  ];
                }
              ];

              window_rule = [
                {
                  match.class = "zen-beta";
                  workspace = 2;
                }
              ];
            };
          })
        ]
      );
}
