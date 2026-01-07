{ pkgs, ... }:
let
  screenShotScript = pkgs.writeShellScriptBin "screenshot" ''
    export PATH=$PATH:${pkgs.hyprshot}/bin

    if command -v hyproled >/dev/null 2>&1; then
        hyproled off
        trap 'hyproled' EXIT
    fi

    hyprshot -m region -o ~/screenshots -z -s "$@"
  '';
in {
  home.packages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    wireplumber
    pipewire
    brightnessctl
    playerctl
    hyprmon
  ];

  services.cliphist.enable = true;

  wayland.windowManager.hyprland = {
    systemd.variables = [ "--all" ];
    enable = true;
    xwayland.enable = true;

    settings = {
      # monitors
      monitor = [ ",preferred,auto,auto" ];

      exec-once = [ "$browser" "$terminal" "hyprpaper" ];

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
        scroll_factor = 0.5;
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad.natural_scroll = false;
        touchpad.scroll_factor = 0.5;
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

        # workspaces
        "$mainmod, 1, workspace, 1"
        "$mainmod, 2, workspace, 2"
        "$mainmod, 3, workspace, 3"
        "$mainmod, 4, workspace, 4"
        "$mainmod, 5, workspace, 5"
        "$mainmod, 6, workspace, 6"
        "$mainmod, 7, workspace, 7"
        "$mainmod, 8, workspace, 8"
        "$mainmod, 9, workspace, 9"
        "$mainmod, 0, workspace, 10"

        "$mainmod shift, 1, movetoworkspace, 1"
        "$mainmod shift, 2, movetoworkspace, 2"
        "$mainmod shift, 3, movetoworkspace, 3"
        "$mainmod shift, 4, movetoworkspace, 4"
        "$mainmod shift, 5, movetoworkspace, 5"
        "$mainmod shift, 6, movetoworkspace, 6"
        "$mainmod shift, 7, movetoworkspace, 7"
        "$mainmod shift, 8, movetoworkspace, 8"
        "$mainmod shift, 9, movetoworkspace, 9"
        "$mainmod shift, 0, movetoworkspace, 10"

        "$mainMod CTRL, 1, exec, hyprctl dispatch moveworkspacetomonitor 1 current && hyprctl dispatch workspace 1"
        "$mainMod CTRL, 2, exec, hyprctl dispatch moveworkspacetomonitor 2 current && hyprctl dispatch workspace 2"
        "$mainMod CTRL, 3, exec, hyprctl dispatch moveworkspacetomonitor 3 current && hyprctl dispatch workspace 3"
        "$mainMod CTRL, 4, exec, hyprctl dispatch moveworkspacetomonitor 4 current && hyprctl dispatch workspace 4"
        "$mainMod CTRL, 5, exec, hyprctl dispatch moveworkspacetomonitor 5 current && hyprctl dispatch workspace 5"
        "$mainMod CTRL, 6, exec, hyprctl dispatch moveworkspacetomonitor 6 current && hyprctl dispatch workspace 6"
        "$mainMod CTRL, 7, exec, hyprctl dispatch moveworkspacetomonitor 7 current && hyprctl dispatch workspace 7"
        "$mainMod CTRL, 8, exec, hyprctl dispatch moveworkspacetomonitor 8 current && hyprctl dispatch workspace 8"
        "$mainMod CTRL, 9, exec, hyprctl dispatch moveworkspacetomonitor 9 current && hyprctl dispatch workspace 9"
        "$mainMod CTRL, 0, exec, hyprctl dispatch moveworkspacetomonitor 0 current && hyprctl dispatch workspace 0"

        ", print, exec, $(${screenShotScript}/bin/screenshot) --clipboard-only"
        "shift, Print, exec, $(${screenShotScript}/bin/screenshot)"
      ];

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
