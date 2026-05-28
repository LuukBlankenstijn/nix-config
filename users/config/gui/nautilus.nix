{ osConfig, lib, pkgs, ... }:
lib.mkIf (osConfig.cfg.userConfig.desktop.enable && osConfig.cfg.userConfig.desktop.nautilus.enable) (
  lib.mkMerge [
    {
      home.packages = [ pkgs.nautilus ];
    }

    (lib.mkIf osConfig.cfg.userConfig.desktop.hyprland.enable {
      wayland.windowManager.hyprland.settings = {
        filemanager = { _var = "${pkgs.nautilus}/bin/nautilus"; };

        bind = [
          {
            _args = [
              (lib.generators.mkLuaInline ''mainmod .. " + E"'')
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(filemanager)")
            ];
          }
        ];

        window_rule = [
          { match.class = "org.gnome.Nautilus"; float = true; }
          { match.class = "org.gnome.Nautilus"; size = "monitor_w*0.7 monitor_h*0.7"; }
          { match.class = "org.gnome.Nautilus"; move = "monitor_w*0.15 monitor_h*0.15"; }
        ];
      };
    })
  ]
)
