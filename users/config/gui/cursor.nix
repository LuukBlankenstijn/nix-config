{ osConfig, lib, pkgs, ... }:
lib.mkIf (osConfig.cfg.userConfig.desktop.enable && osConfig.cfg.userConfig.desktop.cursor.enable) (
  lib.mkMerge [
    {
      home.pointerCursor = {
        enable = true;
        name = "Adwaita";
        size = 24;
        package = pkgs.adwaita-icon-theme;
        gtk.enable = true;
        x11.enable = true;
      };

      home.sessionVariables = {
        XCURSOR_THEME = "Adwaita";
        XCURSOR_SIZE = "24";
        GTK_USE_PORTAL = "1";
      };
    }

    (lib.mkIf osConfig.cfg.userConfig.desktop.hyprland.enable {
      wayland.windowManager.hyprland.settings.on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''
              function()
                hl.exec_cmd("hyprctl setcursor Adwaita 24")
              end
            '')
          ];
        }
      ];
    })

    (lib.mkIf osConfig.cfg.userConfig.desktop.niri.enable {
      programs.niri.settings.cursor = {
        theme = "Adwaita";
        size = 24;
      };
    })
  ]
)
