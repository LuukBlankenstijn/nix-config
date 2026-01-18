{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nautilus
  ];

  wayland.windowManager.hyprland.settings = {
    "$filemanager" = "${pkgs.nautilus}/bin/nautilus";
    bind = [
      "$mainmod, E, exec, $filemanager"
    ];
    windowrule = [
      "match:class org.gnome.Nautilus, float 1"
      "match:class org.gnome.Nautilus, size monitor_w*0.7 monitor_h*0.7"
      "match:class org.gnome.Nautilus, move monitor_w*0.15 monitor_h*0.15"
    ];
  };

}
