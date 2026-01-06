{ pkgs, ... }: {
  services.xserver.enable = false;

  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;
  security.pam.services.hyprlock = { };

  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = ../_assets/nature.jpg;
        fit = "Cover";
      };
      GTK = {
        application_prefer_dark_theme = true;
        cursor_blink = false;
      };
    };
  };

  programs.dconf.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      common = { default = [ "gtk" ]; };
      hyprland = { default = [ "hyprland" "gtk" ]; };
    };
  };
}
