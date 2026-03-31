{ config, lib, pkgs, ... }:
lib.mkIf config.cfg.desktop.enable {
  programs = {
    hyprland.enable = true;
    hyprlock.enable = true;

    regreet = {
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

    dconf.enable = true;
  };

  security.pam.services = {
    hyprlock = { };
    login.enableGnomeKeyring = true;
  };

  services.xserver.enable = false;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [ "hyprland" "gtk" ];
    };
  };
}
