{ pkgs, ... }: {
  home.packages = with pkgs; [ gsettings-desktop-schemas glib ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };
  };
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "candy-icons";
      package = pkgs.candy-icons;
    };
    gtk3.extraConfig = { "gtk-application-prefer-dark-theme" = 1; };

    gtk4.extraConfig = { "gtk-application-prefer-dark-theme" = 1; };
  };

  home.sessionVariables = {
    GTK_THEME = "Adwaita:dark";
    GTK_USE_PORTAL = "1";
    GTK_APPLICATION_PREFER_DARK_THEME = "1";
  };
}
