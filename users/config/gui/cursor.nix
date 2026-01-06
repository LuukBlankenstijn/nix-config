{ pkgs, ... }: {
  home.pointerCursor = {
    name = "Adwaita";
    size = 24;
    package = pkgs.adwaita-icon-theme;
    gtk.enable = true;
    x11.enable = true;
  };

  wayland.windowManager.hyprland.settings.exec-once =
    [ "hyprclt setcursor Adwaita 24" ];

  home.sessionVariables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
    GTK_USE_PORTAL = "1";
  };
}
