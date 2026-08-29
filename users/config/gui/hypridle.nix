{
  osConfig,
  lib,
  pkgs,
  ...
}:
lib.mkIf
  (
    osConfig.cfg.userConfig.desktop.hyprland.enable
    && osConfig.cfg.userConfig.desktop.hyprland.idle.enable
  )
  {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
          before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
          after_sleep_cmd = "${pkgs.wlopm}/bin/wlopm --on '*'";
        };

        listener = [
          {
            timeout = 300;
            on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
            on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
          }
          {
            timeout = 300;
            on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -sd '*kbd_backlight' set 0";
            on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -rd '*kbd_backlight'";
          }
          {
            timeout = 600;
            on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
          }
          {
            timeout = 660;
            on-timeout = "${pkgs.wlopm}/bin/wlopm --off '*'";
            on-resume = "${pkgs.wlopm}/bin/wlopm --on '*' && ${pkgs.brightnessctl}/bin/brightnessctl -r";
          }
          {
            timeout = 1800;
            on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
          }
        ];
      };
    };

    home.packages = [
      pkgs.brightnessctl
      pkgs.hyprlock
    ];
  }
