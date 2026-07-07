{ osConfig, lib, pkgs, ... }:
lib.mkIf (osConfig.cfg.userConfig.desktop.hyprland.enable && osConfig.cfg.userConfig.desktop.hyprland.displays.enable) {
  # wdisplays: GTK GUI to drag-arrange outputs live (via wlr-output-management).
  home.packages = with pkgs; [
    wdisplays
  ];

  # shikane: daemon that auto-applies a layout when the set of connected
  # outputs matches a profile. Talks to Hyprland over wlr-output-management,
  # so it works with the read-only Lua config (unlike `hyprctl keyword`).
  services.shikane = {
    enable = true;
    settings.profile = [
      # Home desk: laptop centered below two Lenovo T22i externals.
      # The externals are matched by serial (s=...), not connector name, so
      # each panel keeps its side regardless of which DP port it lands on.
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
      # Fallback: laptop panel only.
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

  # Super+F2 opens the GUI arranger (replaces the old hyprmon bind).
  wayland.windowManager.hyprland.settings.bind = [
    {
      _args = [
        (lib.generators.mkLuaInline ''mainmod .. " + F2"'')
        (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${pkgs.wdisplays}/bin/wdisplays")'')
      ];
    }
  ];
}
