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
      settings.profile = [
        {
          name = "home-3mon";
          output = [
            {
              search = "n=eDP-1";
              enable = true;
              mode = "2880x1800@120Hz";
              position = "2640,1080";
              scale = 2.0;
            }
            {
              search = "s=V90745TL";
              enable = true;
              mode = "1920x1080@60Hz";
              position = "1440,0";
              scale = 1.0;
            }
            {
              search = "s=V90745TB";
              enable = true;
              mode = "1920x1080@60Hz";
              position = "3360,0";
              scale = 1.0;
            }
          ];
        }
        {
          name = "laptop-only";
          output = [
            {
              search = "n=eDP-1";
              enable = true;
              mode = "2880x1800@120Hz";
              position = "0,0";
              scale = 2.0;
            }
          ];
        }
      ];
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
