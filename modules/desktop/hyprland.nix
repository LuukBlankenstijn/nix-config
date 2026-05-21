{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.cfg.desktop.enable {
    programs.hyprland.enable = true;
    programs.hyprlock.enable = true;

    environment.systemPackages = [ pkgs.hyprpolkitagent ];
  };
}
