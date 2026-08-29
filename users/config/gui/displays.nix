{
  osConfig,
  lib,
  pkgs,
  ...
}:
lib.mkIf
  (
    osConfig.cfg.userConfig.desktop.hyprland.enable
    && osConfig.cfg.userConfig.desktop.hyprland.displays.enable
  )
  {
    home.packages = with pkgs; [
      wdisplays
    ];

    services.shikane = {
      enable = true;
      settings.profile = osConfig.cfg.userConfig.desktop.hyprland.displays.profiles;
    };

    wayland.windowManager.hyprland.settings.bind = [
      {
        _args = [
          (lib.generators.mkLuaInline ''mainmod .. " + F2"'')
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${pkgs.wdisplays}/bin/wdisplays")'')
        ];
      }
    ];
  }
