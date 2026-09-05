{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkIf optionalAttrs;
  userCfg = config.cfg.userConfig;
in
{
  imports = [ inputs.noctalia-greeter.nixosModules.default ];

  config = mkIf (config.cfg.desktop.enable && config.cfg.desktop.displayManager.enable) {
    programs.noctalia-greeter = {
      enable = true;

      settings = {
        appearance = {
          scheme = "Catppuccin";
          theme_mode = "dark";
          wallpaper = {
            path = "${userCfg.desktop.wallpaper}";
            fill_mode = "crop";
          };
        };

        cursor = {
          theme = "Adwaita";
          size = 24;
          path = "${pkgs.adwaita-icon-theme}/share/icons";
        };

        keyboard.layout = "us";
      }
      // optionalAttrs (config.cfg.desktop.displayManager.defaultSession != null) {
        session.default = config.cfg.desktop.displayManager.defaultSession;
      };
    };

    services.xserver.enable = false; # ensure wayland-only
  };
}
