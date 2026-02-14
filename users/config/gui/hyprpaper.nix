_: {
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = "*";
          path = "${./_assets/wallpapers/nature.jpg}";
        }
      ];
    };

  };
}
