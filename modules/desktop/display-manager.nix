{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf (config.cfg.desktop.enable && config.cfg.desktop.displayManager.enable) {
    programs.regreet = {
      enable = true;
      settings = {
        background = {
          path = config.cfg.userConfig.desktop.wallpaper;
        };
        GTK = {
          application_prefer_dark_theme = true;
          cursor_blink = false;
        };
      };
    };

    services.xserver.enable = false; # ensure wayland-only
  };
}
