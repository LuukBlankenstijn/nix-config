{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.cfg.desktop.enable {
    # Tells the nixpkgs Electron/Chromium wrappers to pass Wayland ozone flags,
    # which is what makes the xdg-desktop-portal FileChooser work for Signal et al.
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

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
