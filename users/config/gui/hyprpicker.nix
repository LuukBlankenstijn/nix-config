{ osConfig, lib, pkgs, ... }:
lib.mkIf (osConfig.cfg.userConfig.desktop.hyprland.enable && osConfig.cfg.userConfig.desktop.hyprland.picker.enable) {
  home.packages = with pkgs; [
    hyprpicker
  ];

  wayland.windowManager.hyprland.settings.bind = [
    {
      _args = [
        (lib.generators.mkLuaInline ''mainmod .. " + p"'')
        (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${pkgs.hyprpicker}/bin/hyprpicker")'')
      ];
    }
  ];
}
