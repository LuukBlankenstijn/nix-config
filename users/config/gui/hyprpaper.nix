{ pkgs, ... }: {
  home.packages = [ pkgs.hyprpaper ];

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${./_assets/wallpapers/nature.jpg}
    wallpaper = , ${./_assets/wallpapers/nature.jpg}
    splash = false
  '';
}
