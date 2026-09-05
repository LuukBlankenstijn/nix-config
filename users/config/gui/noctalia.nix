{
  osConfig,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  userCfg = osConfig.cfg.userConfig;

  zenTemplate = ./_assets/noctalia-templates/zen-browser;

  pluginDir = ./_assets/noctalia-plugins;

  claudebar = pkgs.callPackage ./_assets/claudebar.nix { };

  installed = pname: builtins.any (p: (p.pname or p.name or "") == pname) userCfg.extraPackages;

  dockPinned =
    lib.optional userCfg.desktop.terminal.enable "com.mitchellh.ghostty"
    ++ lib.optional userCfg.desktop.browser.enable "zen-beta"
    ++ lib.optional userCfg.desktop.nautilus.enable "org.gnome.Nautilus"
    ++ lib.optional userCfg.desktop.email.enable "thunderbird"
    ++ lib.optional (installed "signal-desktop") "signal"
    ++ lib.optional (installed "slack") "slack"
    ++ lib.optional (installed "discord") "discord"
    ++ lib.optional (installed "spotify") "spotify"
    ++ lib.optional (installed "bitwarden-desktop") "bitwarden";

  msg = args: {
    command = [
      (lib.getExe config.programs.noctalia.package)
      "msg"
    ]
    ++ args;
    sessions = [ "niri" ];
  };

  osdBind =
    args:
    msg args
    // {
      whenLocked = true;
      repeat = true;
    };
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;

    settings = {
      shell = {
        font_family = "JetBrainsMono Nerd Font Mono";
        niri_overview_type_to_launch_enabled = true;
      };

      plugins = {
        enabled = [ "luuk/claudebar" ];
        auto_update = "none";
        source = [
          {
            name = "local";
            kind = "path";
            location = "${pluginDir}";
            enabled = true;
          }
        ];
      };

      widget.claude_usage.type = "luuk/claudebar:bar";

      bar.main = {
        auto_hide = false;
        reserve_space = true;
        end = [
          "claude_usage"
          "tray"
          "notifications"
          "clipboard"
          "network"
          "bluetooth"
          "volume"
          "brightness"
          "battery"
          "control-center"
          "session"
        ];
      };

      widget.network.show_label = false;

      dock = {
        enabled = true;
        auto_hide = true;
        reserve_space = false;
        margin_edge = 16;
        pinned = dockPinned;
      };

      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
        templates = {
          enable_builtin_templates = true;
          builtin_ids = [
            "btop"
            "ghostty"
            "gtk3"
            "gtk4"
          ];

          user.zen_browser_chrome = {
            input_path = "${zenTemplate}/zen-userChrome.css";
            output_path = "${config.xdg.cacheHome}/noctalia/zen-browser/zen-userChrome.css";
            post_hook = "bash ${zenTemplate}/apply.sh";
            hook_async = false;
          };
          user.zen_browser_content = {
            input_path = "${zenTemplate}/zen-userContent.css";
            output_path = "${config.xdg.cacheHome}/noctalia/zen-browser/zen-userContent.css";
            post_hook = "bash ${zenTemplate}/apply.sh";
            hook_async = false;
          };
        };
      };

      wallpaper = {
        enabled = true;
        directory = "${../../../assets/wallpapers}";
        default.path = "${userCfg.desktop.wallpaper}";
      };
      lockscreen.enabled = true;

      calendar = {
        enabled = true;
        refresh_minutes = 15;
        account.google = {
          type = "google";
          name = "Google";
        };
      };
      idle.behavior = {
        lock = {
          enabled = true;
          timeout = 600;
          action = "lock";
        };
        screen-off = {
          enabled = true;
          timeout = 660;
          action = "screen_off";
        };
      };
    };
  };

  programs.niri.settings.spawn-at-startup = [
    { argv = [ (lib.getExe config.programs.noctalia.package) ]; }
  ];

  desktop.binds = {
    launcher =
      msg [
        "panel-toggle"
        "launcher"
      ]
      // {
        key = "Space";
      };
    themeMode = msg [ "theme-mode-toggle" ] // {
      key = "D";
      mods = [
        "mod"
        "shift"
      ];
    };
    controlCenter =
      msg [
        "panel-toggle"
        "control-center"
      ]
      // {
        key = "S";
      };
    shellSettings = msg [ "settings-toggle" ] // {
      key = "Comma";
    };
    windowSwitcher = msg [ "window-switcher" ] // {
      key = "Tab";
      mods = [ "alt" ];
    };
    sessionMenu =
      msg [
        "panel-toggle"
        "session"
      ]
      // {
        key = "X";
      };
    wallpaperPicker =
      msg [
        "panel-toggle"
        "wallpaper"
      ]
      // {
        key = "W";
        mods = [
          "mod"
          "shift"
        ];
      };
    clipboardPanel =
      msg [
        "panel-toggle"
        "clipboard"
      ]
      // {
        key = "V";
        mods = [
          "mod"
          "shift"
        ];
      };
    lockSession =
      msg [
        "session"
        "lock"
      ]
      // {
        key = "Escape";
      };

    volumeUp = osdBind [ "volume-up" ] // {
      key = "XF86AudioRaiseVolume";
      mods = [ ];
    };
    volumeDown = osdBind [ "volume-down" ] // {
      key = "XF86AudioLowerVolume";
      mods = [ ];
    };
    volumeMute = osdBind [ "volume-mute" ] // {
      key = "XF86AudioMute";
      mods = [ ];
    };
    brightnessUp = osdBind [ "brightness-up" ] // {
      key = "XF86MonBrightnessUp";
      mods = [ ];
    };
    brightnessDown = osdBind [ "brightness-down" ] // {
      key = "XF86MonBrightnessDown";
      mods = [ ];
    };
    micMute = {
      key = "XF86AudioMicMute";
      mods = [ ];
      command = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-mute"
        "@DEFAULT_AUDIO_SOURCE@"
        "toggle"
      ];
      whenLocked = true;
      sessions = [ "niri" ];
    };
  };

  gtk = {
    gtk3.extraCss = ''@import url("noctalia.css");'';
    gtk4.extraCss = ''@import url("noctalia.css");'';
  };

  home.packages = [
    claudebar
  ]
  ++ (with pkgs; [
    matugen
    brightnessctl
    wl-clipboard
  ]);
}
