{
  osConfig,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  modNames = {
    mod = "Mod";
    shift = "Shift";
    ctrl = "Ctrl";
    alt = "Alt";
  };

  chord = bind: lib.concatStringsSep "+" (map (m: modNames.${m}) bind.mods ++ [ bind.key ]);

  humanize =
    name:
    let
      spaced = builtins.replaceStrings lib.upperChars (map (c: " ${c}") lib.upperChars) name;
    in
    lib.toUpper (lib.substring 0 1 spaced) + lib.substring 1 (-1) spaced;

  spawnBinds = lib.mapAttrs' (
    name: bind:
    lib.nameValuePair (chord bind) (
      {
        action.spawn = bind.command;
        allow-when-locked = bind.whenLocked;
        repeat = bind.repeat;
        hotkey-overlay.title = humanize name;
      }
      // lib.optionalAttrs (bind.cooldownMs != null) { cooldown-ms = bind.cooldownMs; }
    )
  ) (lib.filterAttrs (_: bind: builtins.elem "niri" bind.sessions) config.desktop.binds);

  act = name: { action.${name} = [ ]; };

  directional = mods: actions: {
    "${mods}+H" = act actions.left;
    "${mods}+J" = act actions.down;
    "${mods}+K" = act actions.up;
    "${mods}+L" = act actions.right;
  };

  workspaceBinds = lib.listToAttrs (
    lib.concatMap (i: [
      (lib.nameValuePair "Mod+${toString i}" { action.focus-workspace = i; })
      (lib.nameValuePair "Mod+Shift+${toString i}" { action.move-window-to-workspace = i; })
    ]) (lib.range 1 9)
  );

  wheelBind = action: {
    action.${action} = [ ];
    cooldown-ms = 150;
  };

  mediaBind = key: args: {
    "XF86Audio${key}" = {
      action.spawn = [ (lib.getExe pkgs.playerctl) ] ++ args;
      allow-when-locked = true;
    };
  };

  pinnedByWorkspace = lib.groupBy (app: app.workspace) (lib.attrValues config.desktop.pinnedApps);

  workspaceKeys = {
    chat = "W";
  };

  ensureRunning = app: ''
    if ! printf '%s\n' "$running" | ${lib.getExe' pkgs.gnugrep "grep"} -qxF ${lib.escapeShellArg app.appId}; then
      ${lib.getExe' pkgs.util-linux "setsid"} ${lib.escapeShellArgs app.command} >/dev/null 2>&1 &
    fi
  '';

  summonWorkspace =
    name: apps:
    pkgs.writeShellScript "niri-summon-${name}" ''
      set -u
      running=$(${lib.getExe pkgs.niri} msg --json windows | ${lib.getExe pkgs.jq} -r '.[].app_id')
      ${lib.concatMapStrings ensureRunning apps}
      exec ${lib.getExe pkgs.niri} msg action focus-workspace ${lib.escapeShellArg name}
    '';

  pinnedBinds = lib.mapAttrs' (
    name: apps:
    lib.nameValuePair "Mod+${workspaceKeys.${name}}" {
      action.spawn = [ "${summonWorkspace name apps}" ];
      repeat = false;
      hotkey-overlay.title = humanize name;
    }
  ) (lib.filterAttrs (name: _: workspaceKeys ? ${name}) pinnedByWorkspace);

  blackout = pkgs.writeShellScript "niri-blackout" ''
    set -u

    niri=${lib.getExe pkgs.niri}
    brightnessctl=${lib.getExe pkgs.brightnessctl}
    loginctl=${lib.getExe' pkgs.systemd "loginctl"}
    systemctl=${lib.getExe' pkgs.systemd "systemctl"}
    sleep=${lib.getExe' pkgs.coreutils "sleep"}

    locked() {
      session=$($loginctl show-user "$(${lib.getExe' pkgs.coreutils "id"} -un)" -p Display --value)
      [ "$($loginctl show-session "$session" -p LockedHint --value)" = yes ]
    }

    restore() {
      $niri msg action power-on-monitors
      $brightnessctl -rd '*kbd_backlight'
    }

    hold() {
      trap 'restore; exit 0' EXIT TERM INT
      $brightnessctl -sd '*kbd_backlight' set 0
      $loginctl lock-session

      waited=0
      while [ "$waited" -lt 20 ] && ! locked; do
        $sleep 0.25
        waited=$((waited + 1))
      done

      $niri msg action power-off-monitors

      while $sleep 0.5; do
        locked || return
      done
    }

    if [ "''${1-}" = hold ]; then
      hold
      exit
    fi

    if $systemctl --user --quiet is-active niri-blackout.service; then
      $systemctl --user stop niri-blackout.service
    else
      ${lib.getExe' pkgs.systemd "systemd-run"} --user --unit=niri-blackout \
        --description="displays off, machine stays awake" \
        ${lib.getExe' pkgs.systemd "systemd-inhibit"} \
          --what=idle:sleep:handle-lid-switch \
          --why="blackout" \
          --mode=block \
          "$0" hold
    fi
  '';
in
{
  programs.niri.settings = {
    prefer-no-csd = true;
    hotkey-overlay.skip-at-startup = true;
    screenshot-path = "~/screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

    xwayland-satellite = {
      enable = true;
      path = lib.getExe pkgs.xwayland-satellite;
    };

    input = {
      keyboard.xkb.layout = "us";
      focus-follows-mouse.enable = true;
      touchpad = {
        tap = true;
        natural-scroll = false;
        scroll-factor = 1.2;
      };
    };

    outputs = osConfig.cfg.userConfig.desktop.niri.outputs;

    layout = {
      gaps = 4;
      border.enable = false;
      focus-ring.enable = false;
      default-column-width.proportion = 0.5;
      preset-column-widths = [
        { proportion = 1.0 / 3.0; }
        { proportion = 0.5; }
        { proportion = 2.0 / 3.0; }
      ];
    };

    workspaces = lib.genAttrs (lib.attrNames pinnedByWorkspace) (_: { });

    window-rules = lib.mapAttrsToList (
      _: app:
      {
        matches = [ { app-id = "^${lib.escapeRegex app.appId}$"; } ];
        open-on-workspace = app.workspace;
      }
      // lib.optionalAttrs (app.columnWidth != null) {
        default-column-width.proportion = app.columnWidth;
      }
    ) config.desktop.pinnedApps;

    spawn-at-startup = lib.mapAttrsToList (_: app: { argv = app.command; }) config.desktop.pinnedApps;

    binds = lib.foldl' lib.attrsets.unionOfDisjoint spawnBinds [
      pinnedBinds
      workspaceBinds
      (directional "Mod" {
        left = "focus-column-left";
        down = "focus-window-down";
        up = "focus-window-up";
        right = "focus-column-right";
      })
      (directional "Mod+Shift" {
        left = "move-column-left";
        down = "move-window-down";
        up = "move-window-up";
        right = "move-column-right";
      })
      (directional "Mod+Ctrl" {
        left = "focus-monitor-left";
        down = "focus-monitor-down";
        up = "focus-monitor-up";
        right = "focus-monitor-right";
      })
      (directional "Mod+Ctrl+Shift" {
        left = "move-column-to-monitor-left";
        down = "move-column-to-monitor-down";
        up = "move-column-to-monitor-up";
        right = "move-column-to-monitor-right";
      })
      {
        "Mod+C" = act "close-window";
        "Mod+V" = act "toggle-window-floating";
        "Mod+Ctrl+V" = act "switch-focus-between-floating-and-tiling";
        "Mod+F" = act "maximize-column";
        "Mod+Shift+F" = act "fullscreen-window";
        "Mod+Ctrl+F" = act "expand-column-to-available-width";
        "Mod+T" = act "toggle-column-tabbed-display";
        "Mod+O" = act "toggle-overview";

        "Mod+Shift+B" = {
          action.spawn = [ "${blackout}" ];
          allow-when-locked = true;
          repeat = false;
          hotkey-overlay.title = "Blackout";
        };
        "Mod+Shift+Slash" = act "show-hotkey-overlay";

        "Mod+BracketLeft" = act "consume-or-expel-window-left";
        "Mod+BracketRight" = act "consume-or-expel-window-right";
        "Mod+Period" = act "consume-window-into-column";
        "Mod+Slash" = act "expel-window-from-column";

        "Mod+R" = act "switch-preset-column-width";
        "Mod+Ctrl+R" = act "switch-preset-window-height";
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";
        "Mod+Shift+C" = act "center-column";

        "Mod+Home" = act "focus-column-first";
        "Mod+End" = act "focus-column-last";
        "Mod+Ctrl+Home" = act "move-column-to-first";
        "Mod+Ctrl+End" = act "move-column-to-last";

        "Mod+Tab" = act "focus-window-previous";
        "Mod+Page_Down" = act "focus-workspace-down";
        "Mod+Page_Up" = act "focus-workspace-up";
        "Mod+WheelScrollDown" = wheelBind "focus-workspace-down";
        "Mod+WheelScrollUp" = wheelBind "focus-workspace-up";

        "Mod+WheelScrollRight" = act "focus-column-right";
        "Mod+WheelScrollLeft" = act "focus-column-left";
        "Mod+Shift+WheelScrollDown" = act "focus-column-right";
        "Mod+Shift+WheelScrollUp" = act "focus-column-left";

        "Print" = act "screenshot";
        "Ctrl+Print" = act "screenshot-screen";
        "Alt+Print" = act "screenshot-window";

        "Mod+M".action.quit = [ ];
      }
      (mediaBind "Play" [ "play-pause" ])
      (mediaBind "Pause" [ "play-pause" ])
      (mediaBind "Next" [ "next" ])
      (mediaBind "Prev" [ "previous" ])
    ];
  };
}
