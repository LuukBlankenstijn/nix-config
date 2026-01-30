{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprmon
  ];

  wayland.windowManager.hyprland.settings.bind = [
    "$mainmod, f1, exec, ${pkgs.ghostty}/bin/ghostty -e hyprmon -profiles"
    "$mainmod, f2, exec, ${pkgs.ghostty}/bin/ghostty -e hyprmon"
  ];
}
