{
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe
    getExe'
    mkIf
    optionals
    ;

  touch = osConfig.cfg.desktop.touchscreen;
  desktop = osConfig.cfg.userConfig.desktop;

  enabled = desktop.enable && touch.enable && (desktop.niri.enable || desktop.hyprland.enable);

  # Catppuccin Mocha, so the keyboard sits in the session rather than on top of it.
  keyboardColors = [
    "--bg"
    "1e1e2e"
    "--fg"
    "313244"
    "--fg-sp"
    "45475a"
    "--press"
    "89b4fa"
    "--press-sp"
    "89b4fa"
    "--swipe"
    "585b70"
    "--swipe-sp"
    "585b70"
    "--text"
    "cdd6f4"
    "--text-sp"
    "cdd6f4"
  ];

  keyboardArgs = [
    "--hidden"
    "-H"
    (toString touch.keyboard.height)
    "-L"
    (toString touch.keyboard.landscapeHeight)
  ]
  ++ lib.optional touch.keyboard.autoShow "--auto"
  ++ keyboardColors
  ++ touch.keyboard.extraArgs;

  # wvkbd's own toggle signal flips a flag --hidden already set before the surface
  # existed, so the first press after login lands on the wrong side of it. Asking
  # the compositor what is actually on screen keeps the bind honest both ways,
  # including when autoShow raised the keyboard by itself.
  oskToggle = pkgs.writeShellScriptBin "osk-toggle" ''
    set -u

    shown() {
      case "''${XDG_CURRENT_DESKTOP-}" in
        niri)
          ${getExe pkgs.niri} msg --json layers \
            | ${getExe pkgs.jq} -e 'any(.[]; .namespace == "wvkbd")' >/dev/null
          ;;
        Hyprland)
          ${getExe' pkgs.hyprland "hyprctl"} -j layers \
            | ${getExe pkgs.jq} -e '[.. | objects | select(.namespace? == "wvkbd")] | length > 0' >/dev/null
          ;;
        *)
          return 1
          ;;
      esac
    }

    if shown; then
      exec ${getExe' pkgs.procps "pkill"} --signal SIGUSR1 --exact wvkbd-mobintl
    else
      exec ${getExe' pkgs.procps "pkill"} --signal SIGUSR2 --exact wvkbd-mobintl
    fi
  '';

  # One gesture daemon serves both sessions, so a swipe only decides what it
  # means once it can see which compositor is listening.
  dispatch = pkgs.writeShellScript "touch-gesture" ''
    set -eu

    case "''${XDG_CURRENT_DESKTOP-}" in
      niri)
        niri=${getExe pkgs.niri}
        case "$1" in
          overview)       exec $niri msg action toggle-overview ;;
          workspace-next) exec $niri msg action focus-workspace-down ;;
          workspace-prev) exec $niri msg action focus-workspace-up ;;
          column-left)    exec $niri msg action focus-column-left ;;
          column-right)   exec $niri msg action focus-column-right ;;
        esac
        ;;
      Hyprland)
        hyprctl=${getExe' pkgs.hyprland "hyprctl"}
        case "$1" in
          # Hyprland 0.56 has no overview of its own and hyprgrass no longer
          # builds against it, so the top-edge swipe stays unbound here. Point it
          # somewhere with cfg.desktop.touchscreen.gestures.extra if you want it.
          workspace-next) exec $hyprctl dispatch workspace e+1 ;;
          workspace-prev) exec $hyprctl dispatch workspace e-1 ;;
          column-left)    exec $hyprctl dispatch movefocus l ;;
          column-right)   exec $hyprctl dispatch movefocus r ;;
        esac
        ;;
    esac
  '';

  # lisgd measures in whatever units -w/-h are given in, so the threshold is a
  # fraction of the short side rather than a pixel count nobody can calibrate.
  shortSide = lib.min touch.size.width touch.size.height;
  threshold = builtins.floor (touch.gestures.threshold * shortSide);

  # Directions are named after where the finger goes; the content follows it, so
  # swiping up walks down the workspace column and swiping left walks right
  # through the columns.
  gestureSpecs = [
    "1,UD,T,*,R,${dispatch} overview"
    "3,DU,*,*,R,${dispatch} workspace-next"
    "3,UD,*,*,R,${dispatch} workspace-prev"
    "3,RL,*,*,R,${dispatch} column-right"
    "3,LR,*,*,R,${dispatch} column-left"
  ]
  ++ optionals touch.keyboard.enable [
    "1,DU,B,*,R,${oskToggle}/bin/osk-toggle"
  ]
  ++ touch.gestures.extra;

  lisgdArgs = [
    "-d"
    "/dev/input/touchscreen"
    "-t"
    (toString threshold)
    "-m"
    (toString touch.gestures.timeoutMs)
    # Pinned explicitly: left to itself lisgd asks Wayland for the screen size and
    # gets whichever output it happens to enumerate first, which is not the panel
    # under your finger once the laptop is docked.
    "-w"
    (toString touch.size.width)
    "-h"
    (toString touch.size.height)
  ]
  ++ lib.concatMap (spec: [
    "-g"
    spec
  ]) gestureSpecs;

  # Both sessions reach graphical-session.target, so these units follow whichever
  # one is running without needing to know which that is.
  sessionUnit = description: {
    Unit = {
      Description = description;
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = [ "WAYLAND_DISPLAY" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
in
mkIf enabled {
  systemd.user.services =
    lib.optionalAttrs touch.keyboard.enable {
      wvkbd = lib.recursiveUpdate (sessionUnit "on-screen keyboard") {
        Service = {
          ExecStart = "${getExe' pkgs.wvkbd "wvkbd-mobintl"} ${lib.escapeShellArgs keyboardArgs}";
          Restart = "on-failure";
          RestartSec = 2;
        };
      };
    }
    // lib.optionalAttrs touch.gestures.enable {
      lisgd = lib.recursiveUpdate (sessionUnit "touchscreen gesture daemon") {
        Service = {
          ExecStart = "${getExe pkgs.lisgd} ${lib.escapeShellArgs lisgdArgs}";
          Restart = "on-failure";
          RestartSec = 2;
        };
      };
    };

  desktop.binds.onScreenKeyboard = mkIf touch.keyboard.enable {
    key = "I";
    command = [ "${oskToggle}/bin/osk-toggle" ];
  };

  home.packages = lib.optional touch.keyboard.enable oskToggle;
}
