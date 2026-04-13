{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.cfg.desktop.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config = {
        common.default = [ "gtk" ];
        hyprland.default = [ "hyprland" "gtk" ];
      };
    };
  };
}
