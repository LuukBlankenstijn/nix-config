{ osConfig, lib, ... }:
lib.mkIf (osConfig.cfg.userConfig.desktop.hyprland.enable && osConfig.cfg.userConfig.desktop.hyprland.paper.enable) {
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = "*";
          path = "${osConfig.cfg.userConfig.desktop.wallpaper}";
        }
      ];
    };

  };
}
