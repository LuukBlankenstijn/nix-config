{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.generators) mkLuaInline;

  hyprModNames = {
    mod = "SUPER";
    shift = "SHIFT";
    ctrl = "CTRL";
    alt = "ALT";
  };

  registryBinds = lib.mapAttrsToList (_: bind: {
    _args = [
      (lib.concatStringsSep " + " (map (m: hyprModNames.${m}) bind.mods ++ [ bind.key ]))
      (mkLuaInline ''hl.dsp.exec_cmd("${lib.escapeShellArgs bind.command}")'')
    ]
    ++ lib.optional (bind.whenLocked || bind.repeat) {
      locked = bind.whenLocked;
      repeating = bind.repeat;
    };
  }) (lib.filterAttrs (_: bind: builtins.elem "hyprland" bind.sessions) config.desktop.binds);

  screenShotScript = pkgs.writeShellScriptBin "screenshot" ''
    export PATH=$PATH:${pkgs.hyprshot}/bin

    mkdir -p ~/screenshots

    clipboard_only=0
    for a in "$@"; do
      [ "$a" = "--clipboard-only" ] && clipboard_only=1
    done

    before=$(ls -t ~/screenshots 2>/dev/null | head -n1)

    if command -v hyproled >/dev/null 2>&1; then
        hyproled off
        trap 'hyproled' EXIT
    fi

    hyprshot -m region -o ~/screenshots -z -s "$@"

    after=$(ls -t ~/screenshots 2>/dev/null | head -n1)
    if [ "$clipboard_only" -eq 0 ] && [ -n "$after" ] && [ "$before" != "$after" ]; then
      ${pkgs.libnotify}/bin/notify-send -a Screenshot -i "$HOME/screenshots/$after" "Screenshot saved" "$HOME/screenshots/$after"
    fi
  '';

  blackoutScript = pkgs.writeShellScriptBin "blackout" ''
    hyprctl=${pkgs.hyprland}/bin/hyprctl
    brightnessctl=${pkgs.brightnessctl}/bin/brightnessctl

    anyDisplayOn() {
      $hyprctl monitors | ${pkgs.gnugrep}/bin/grep -q 'dpmsStatus: 1'
    }

    restore() {
      anyDisplayOn || $hyprctl dispatch 'hl.dsp.dpms({})'
      $brightnessctl -rd '*kbd_backlight'
    }

    hold() {
      trap 'restore; exit 0' EXIT TERM INT
      $brightnessctl -sd '*kbd_backlight' set 0
      ${pkgs.systemd}/bin/loginctl lock-session
      ${pkgs.coreutils}/bin/sleep 1
      $hyprctl dispatch 'hl.dsp.dpms({})'

      while ${pkgs.coreutils}/bin/sleep 0.5; do
        anyDisplayOn && return
      done
    }

    if [ "$1" = "hold" ]; then
      hold
      exit
    fi

    if ${pkgs.systemd}/bin/systemctl --user --quiet is-active blackout.service; then
      ${pkgs.systemd}/bin/systemctl --user stop blackout.service
    else
      ${pkgs.systemd}/bin/systemd-run --user --unit=blackout \
        --description="displays off, machine stays awake" \
        ${pkgs.systemd}/bin/systemd-inhibit \
          --what=idle:sleep:handle-lid-switch \
          --why="blackout" \
          --mode=block \
          "$0" hold
    fi
  '';

  workspaceFocusBinds = builtins.map (i: {
    _args = [
      (mkLuaInline ''mainmod .. " + ${toString i}"'')
      (mkLuaInline "hl.dsp.focus({ workspace = ${toString i} })")
    ];
  }) (lib.range 1 9);

  workspaceMoveBinds = builtins.map (i: {
    _args = [
      (mkLuaInline ''mainmod .. " + SHIFT + ${toString i}"'')
      (mkLuaInline "hl.dsp.window.move({ workspace = ${toString i} })")
    ];
  }) (lib.range 1 9);

  workspaceToMonitorBinds = builtins.map (i: {
    _args = [
      (mkLuaInline ''mainmod .. " + CTRL + ${toString i}"'')
      (mkLuaInline ''
        function()
          hl.dispatch(hl.dsp.workspace.move({ workspace = ${toString i}, monitor = "current" }))
          hl.dispatch(hl.dsp.focus({ workspace = ${toString i} }))
        end
      '')
    ];
  }) (lib.range 1 9);

  mediaBind = key: cmd: {
    _args = [
      key
      (mkLuaInline ''hl.dsp.exec_cmd("${cmd}")'')
      {
        locked = true;
        repeating = true;
      }
    ];
  };

  mediaBindLocked = key: cmd: {
    _args = [
      key
      (mkLuaInline ''hl.dsp.exec_cmd("${cmd}")'')
      { locked = true; }
    ];
  };
in
lib.mkIf osConfig.cfg.userConfig.desktop.hyprland.enable {
  home.packages = [
    blackoutScript
  ]
  ++ (with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    wireplumber
    pipewire
    brightnessctl
    playerctl
  ]);

  wayland.systemd.target = "hyprland-session.target";

  systemd.user.services =
    lib.genAttrs
      [
        "waybar"
        "swaync"
        "hyprpaper"
        "hyprshell"
        "hypridle"
        "shikane"
        "cliphist"
        "cliphist-images"
      ]
      (_: {
        Unit.ConditionEnvironment = lib.mkForce [
          "WAYLAND_DISPLAY"
          "XDG_CURRENT_DESKTOP=Hyprland"
        ];
      });

  wayland.windowManager.hyprland = {
    systemd.variables = [ "--all" ];
    enable = true;
    xwayland.enable = true;
    configType = "lua";

    settings = {
      mainmod = {
        _var = "SUPER";
      };

      on = [
        {
          _args = [
            "hyprland.start"
            (mkLuaInline ''
              function()
                hl.exec_cmd("systemctl --user start hyprpolkitagent")
              end
            '')
          ];
        }
      ];

      monitor = [
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = "auto";
        }
      ];

      config = {
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
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };

        animations.enabled = true;

        dwindle.preserve_split = true;
        master.new_status = "master";

        misc = {
          force_default_wallpaper = 1;
          disable_hyprland_logo = false;
          key_press_enables_dpms = true;
          mouse_move_enables_dpms = true;
        };

        input = {
          scroll_factor = 1;
          kb_layout = "us";
          follow_mouse = 1;
          sensitivity = 0;
          touchpad = {
            natural_scroll = false;
            scroll_factor = 0.8;
          };
        };
      };

      curve = {
        _args = [
          "myBezier"
          {
            type = "bezier";
            points = [
              [
                0.05
                0.9
              ]
              [
                0.1
                1.05
              ]
            ];
          }
        ];
      };

      gesture = [
        {
          fingers = 3;
          direction = "horizontal";
          action = "workspace";
        }
        {
          fingers = 3;
          direction = "up";
          action = "fullscreen";
        }
        {
          fingers = 3;
          direction = "down";
          action = "fullscreen";
        }
      ];

      animation = [
        {
          _args = [
            {
              leaf = "windows";
              enabled = true;
              speed = 7;
              bezier = "myBezier";
            }
          ];
        }
        {
          _args = [
            {
              leaf = "windowsOut";
              enabled = true;
              speed = 7;
              bezier = "default";
              style = "popin 80%";
            }
          ];
        }
        {
          _args = [
            {
              leaf = "border";
              enabled = true;
              speed = 10;
              bezier = "default";
            }
          ];
        }
        {
          _args = [
            {
              leaf = "borderangle";
              enabled = true;
              speed = 8;
              bezier = "default";
            }
          ];
        }
        {
          _args = [
            {
              leaf = "fade";
              enabled = true;
              speed = 7;
              bezier = "default";
            }
          ];
        }
        {
          _args = [
            {
              leaf = "workspaces";
              enabled = true;
              speed = 6;
              bezier = "default";
            }
          ];
        }
      ];

      bind = [
        # window mgmt
        {
          _args = [
            (mkLuaInline ''mainmod .. " + C"'')
            (mkLuaInline "hl.dsp.window.close()")
          ];
        }
        {
          _args = [
            (mkLuaInline ''mainmod .. " + M"'')
            (mkLuaInline "hl.dsp.exit()")
          ];
        }
        {
          _args = [
            (mkLuaInline ''mainmod .. " + V"'')
            (mkLuaInline ''hl.dsp.window.float({ action = "toggle" })'')
          ];
        }
        {
          _args = [
            (mkLuaInline ''mainmod .. " + F"'')
            (mkLuaInline "hl.dsp.window.fullscreen()")
          ];
        }

        # blackout
        {
          _args = [
            (mkLuaInline ''mainmod .. " + SHIFT + B"'')
            (mkLuaInline ''hl.dsp.exec_cmd("${blackoutScript}/bin/blackout")'')
            { locked = true; }
          ];
        }

        # focus
        {
          _args = [
            (mkLuaInline ''mainmod .. " + h"'')
            (mkLuaInline ''hl.dsp.focus({ direction = "left" })'')
          ];
        }
        {
          _args = [
            (mkLuaInline ''mainmod .. " + l"'')
            (mkLuaInline ''hl.dsp.focus({ direction = "right" })'')
          ];
        }
        {
          _args = [
            (mkLuaInline ''mainmod .. " + k"'')
            (mkLuaInline ''hl.dsp.focus({ direction = "up" })'')
          ];
        }
        {
          _args = [
            (mkLuaInline ''mainmod .. " + j"'')
            (mkLuaInline ''hl.dsp.focus({ direction = "down" })'')
          ];
        }

        # screenshots
        {
          _args = [
            "Print"
            (mkLuaInline ''hl.dsp.exec_cmd("$(${screenShotScript}/bin/screenshot --clipboard-only)")'')
          ];
        }
        {
          _args = [
            "SHIFT + Print"
            (mkLuaInline ''hl.dsp.exec_cmd("$(${screenShotScript}/bin/screenshot)")'')
          ];
        }

        # mouse move/resize
        {
          _args = [
            (mkLuaInline ''mainmod .. " + mouse:272"'')
            (mkLuaInline "hl.dsp.window.drag()")
            { mouse = true; }
          ];
        }
        {
          _args = [
            (mkLuaInline ''mainmod .. " + mouse:273"'')
            (mkLuaInline "hl.dsp.window.resize()")
            { mouse = true; }
          ];
        }

        # volume / brightness (locked + repeating)
        (mediaBind "XF86AudioRaiseVolume" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
        (mediaBind "XF86AudioLowerVolume" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
        (mediaBind "XF86AudioMute" "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
        (mediaBind "XF86AudioMicMute" "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")
        (mediaBind "XF86MonBrightnessUp" "brightnessctl s 10%+")
        (mediaBind "XF86MonBrightnessDown" "brightnessctl s 10%-")

        # media (locked only)
        (mediaBindLocked "XF86AudioNext" "playerctl next")
        (mediaBindLocked "XF86AudioPause" "playerctl play-pause")
        (mediaBindLocked "XF86AudioPlay" "playerctl play-pause")
        (mediaBindLocked "XF86AudioPrev" "playerctl previous")
      ]
      ++ workspaceFocusBinds
      ++ workspaceMoveBinds
      ++ workspaceToMonitorBinds
      ++ registryBinds;
    };
  };
}
