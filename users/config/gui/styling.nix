{
  osConfig,
  lib,
  pkgs,
  config,
  ...
}:
let
  followsShell = osConfig.cfg.userConfig.desktop.niri.noctalia.enable;
in
lib.mkIf (osConfig.cfg.userConfig.desktop.enable && osConfig.cfg.userConfig.desktop.styling.enable)
  {
    home.packages =
      with pkgs;
      [
        gsettings-desktop-schemas
        glib
        nerd-fonts.jetbrains-mono
      ]
      ++ lib.optional followsShell adw-gtk3;

    dconf.settings = lib.mkIf (!followsShell) {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Adwaita-dark";
      };
    };

    gtk = {
      enable = true;
      theme = lib.mkIf (!followsShell) {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      iconTheme = {
        name = "candy-icons";
        package = pkgs.candy-icons;
      };
      gtk3.extraConfig = lib.mkIf (!followsShell) { "gtk-application-prefer-dark-theme" = 1; };
      gtk4 = {
        inherit (config.gtk) theme;
        inherit (config.gtk) iconTheme;
        extraConfig = lib.mkIf (!followsShell) { "gtk-application-prefer-dark-theme" = 1; };
      };
    };

    home.sessionVariables = {
      GTK_USE_PORTAL = "1";
    }
    // lib.optionalAttrs (!followsShell) { GTK_APPLICATION_PREFER_DARK_THEME = "1"; };

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "JetBrainsMono Nerd Font" ];
        serif = [ "JetBrainsMono Nerd Font" ];
      };
    };
  }
