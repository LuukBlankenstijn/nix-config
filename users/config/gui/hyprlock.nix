{
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  whatsongScript = pkgs.writeShellScriptBin "whatsong" ''
    export PATH=$PATH:${pkgs.playerctl}/bin
    ${builtins.readFile ./_assets/scripts/hyprlock/whatsong.sh}
  '';
in
lib.mkIf
  (
    osConfig.cfg.userConfig.desktop.hyprland.enable
    && osConfig.cfg.userConfig.desktop.hyprland.lock.enable
  )
  {
    programs.hyprlock = {
      enable = true;
      settings = {
        # BACKGROUND
        background = [
          {
            monitor = "";
            path = "${osConfig.cfg.userConfig.desktop.hyprland.lock.wallpaper}";
            blur_passes = 2;
            contrast = 1;
            brightness = 0.5;
            vibrancy = 1;
            vibrancy_darkness = 0.2;
          }
        ];
        # GENERAL
        general = {
          hide_cursor = true;
          fail_timeout = 300;
        };
        # AUTH
        auth = lib.optionalAttrs osConfig.services.fprintd.enable {
          fingerprint = {
            enabled = true;
            present_message = "Scanning...";
          };
        };
        # INPUT FIELD
        "input-field" = [
          {
            monitor = "eDP-1";
            size = "250, 60";
            outline_thickness = 0;
            dots_size = 0.2;
            dots_spacing = 0.35;
            dots_center = true;
            outer_color = "rgba(0, 0, 0, 0.2)";
            inner_color = "rgba(0, 0, 0, 0)";
            font_color = "rgb(205, 214, 244)";
            fade_on_empty = true;
            rounding = -1;
            check_color = "rgb(204, 136, 34)";
            placeholder_text = ''<i><span foreground="##cdd6f4">Input Password...</span></i>'';
            hide_input = false;
            position = "0, -200";
            halign = "center";
            valign = "center";
          }
        ];
        # LABELS (Date, Time, Song, Battery)
        label = [
          # DATE
          {
            monitor = "";
            text = ''cmd[update:1000] echo "$(date +"%A, %B %d")"'';
            color = "rgba(242, 243, 244, 0.75)";
            font_size = 22;
            font_family = "JetBrains Mono";
            position = "0, 300";
            halign = "center";
            valign = "center";
          }
          # TIME
          {
            monitor = "";
            text = ''cmd[update:1000] echo "$(date +"%-I:%M")"'';
            color = "rgba(242, 243, 244, 0.75)";
            font_size = 95;
            font_family = "JetBrains Mono Extrabold";
            position = "0, 200";
            halign = "center";
            valign = "center";
          }
          # CURRENT SONG
          {
            monitor = "eDP-1";
            text = ''cmd[update:1000] echo "$(${whatsongScript}/bin/whatsong)"'';
            color = "rgb(205, 214, 244)";
            font_size = 18;
            halign = "center";
            position = "0, 50";
            valign = "bottom";
          }
          # BATTERY PERCENTAGE
          {
            monitor = "eDP-1";
            text = ''cmd[update:1000] echo "$(cat /sys/class/power_supply/BAT0/capacity)%"'';
            color = "rgb(205, 214, 244)";
            font_size = 24;
            font_family = "JetBrains Mono";
            position = "10, -10";
            halign = "right";
            valign = "top";
          }
        ];
      };
    };
    wayland.windowManager.hyprland.settings.bind = [
      {
        _args = [
          (lib.generators.mkLuaInline ''mainmod .. " + escape"'')
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock")'')
        ];
      }
    ];
  }
