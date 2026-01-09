{ pkgs, lib, ... }:
let
  screenShotScript = pkgs.writeShellScriptBin "screenshot" ''
    export PATH=$PATH:${pkgs.hyprshot}/bin

    if command -v hyproled >/dev/null 2>&1; then
        hyproled off
        trap 'hyproled' EXIT
    fi

    hyprshot -m region -o ~/screenshots -z -s "$@"
  '';
in
{
  home.packages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    wireplumber
    pipewire
    brightnessctl
    playerctl
  ];

  services.cliphist.enable = true;

  wayland.windowManager.hyprland = {
    systemd.variables = [ "--all" ];
    enable = true;
    xwayland.enable = true;

    settings = {
      # monitors
      monitor = [ ",preferred,auto,auto" ];

      exec-once = [
        "$browser"
        "$terminal"
        "hyprpaper"
      ];

      # vars
      "$terminal" = "kitty";
      "$filemanager" = "nautilus";
      "$browser" = "zen";
      "$mainmod" = "SUPER";

      general = {
        gaps_in = 2;
        gaps_out = 2;
        border_size = 0;
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 5;
        active_opacity = 1.0;
        inactive_opacity = 0.85;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;
        bezier = [ "myBezier, 0.05, 0.9, 0.1, 1.05" ];
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master.new_status = "master";

      misc = {
        force_default_wallpaper = 1;
        disable_hyprland_logo = false;
      };

      # input
      input = {
        scroll_factor = 1;
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad.natural_scroll = false;
        touchpad.scroll_factor = 0.8;
      };

      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        "workspace 1, class:(kitty)"
        "workspace 2, class:(zen-beta)"
      ];

      # keybinds
      bind = [
        # apps
        "$mainmod, Q, exec, $terminal"
        "$mainmod, B, exec, $browser"
        "$mainmod, E, exec, $filemanager"

        # window mgmt
        "$mainmod, C, killactive,"
        "$mainmod, M, exit,"
        "$mainmod, V, togglefloating,"
        "$mainmod, F, fullscreen"

        # focus
        "$mainmod, h, movefocus, l"
        "$mainmod, l, movefocus, r"
        "$mainmod, k, movefocus, u"
        "$mainmod, j, movefocus, d"

        ", print, exec, $(${screenShotScript}/bin/screenshot) --clipboard-only"
        "shift, Print, exec, $(${screenShotScript}/bin/screenshot)"
      ]
      # focus workspace
      ++ (builtins.map (i: "$mainmod, ${toString i}, workspace, ${toString i}") (lib.range 1 9))
      # move current window to workspace
      ++ (builtins.map (i: "$mainmod shift, ${toString i}, movetoworkspace, ${toString i}") (
        lib.range 1 9
      ))
      # move workspace to monitor
      ++ (builtins.map (
        i:
        "$mainmod CTRL, ${toString i}, exec, hyprctl dispatch moveworkspacetomonitor ${toString i} current && hyprctl dispatch workspace ${toString i}"
      ) (lib.range 1 9));

      # mouse move/resize
      bindm = [
        "$mainmod, mouse:272, movewindow"
        "$mainmod, mouse:273, resizewindow"
      ];

      bindel = [
        ", xf86audioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", xf86audioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", xf86audioMute,        exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", xf86audioMicMute,     exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", xf86monBrightnessUp,   exec, brightnessctl s 10%+"
        ", xf86monBrightnessDown, exec, brightnessctl s 10%-"
      ];

      bindl = [
        ", xf86audioNext,  exec, playerctl next"
        ", xf86audioPause, exec, playerctl play-pause"
        ", xf86audioPlay,  exec, playerctl play-pause"
        ", xf86audioPrev,  exec, playerctl previous"
      ];
    };
  };
}
