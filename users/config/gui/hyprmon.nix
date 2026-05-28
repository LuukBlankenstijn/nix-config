{ osConfig, lib, pkgs, ... }:
lib.mkIf (osConfig.cfg.userConfig.desktop.hyprland.enable && osConfig.cfg.userConfig.desktop.hyprland.mon.enable) {
  home.packages = with pkgs; [
    hyprmon
  ];

  wayland.windowManager.hyprland.settings.bind = [
    {
      _args = [
        (lib.generators.mkLuaInline ''mainmod .. " + F1"'')
        (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${pkgs.ghostty}/bin/ghostty -e hyprmon -profiles")'')
      ];
    }
    {
      _args = [
        (lib.generators.mkLuaInline ''mainmod .. " + F2"'')
        (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${pkgs.ghostty}/bin/ghostty -e hyprmon")'')
      ];
    }
  ];
}
