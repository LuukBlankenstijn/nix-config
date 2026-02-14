{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprpicker
  ];

  wayland.windowManager.hyprland.settings.bind = [
    "$mainmod, p, exec, ${pkgs.hyprpicker}/bin/hyprpicker"
  ];
}
