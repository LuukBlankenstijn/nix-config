{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprmon
  ];

  wayland.windowManager.hyprland.settings.bind = [
    "$mainmod, f1, exec, kitty -e hyprmon -profiles"
    "$mainmod, f2, exec, kitty -e hyprmon"
  ];
}
