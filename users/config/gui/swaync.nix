{ osConfig, lib, ... }:
let
  inherit (lib.generators) mkLuaInline;
  hyprEnabled = osConfig.cfg.userConfig.desktop.hyprland.enable;
in
lib.mkIf (osConfig.cfg.userConfig.desktop.enable && osConfig.cfg.userConfig.desktop.notifications.enable) {
  wayland.windowManager.hyprland.settings.bind = lib.mkIf hyprEnabled [
    { _args = [ (mkLuaInline ''mainmod .. " + N"'') (mkLuaInline ''hl.dsp.exec_cmd("swaync-client -t -sw")'') ]; }
    { _args = [ (mkLuaInline ''mainmod .. " + SHIFT + N"'') (mkLuaInline ''hl.dsp.exec_cmd("swaync-client -C")'') ]; }
  ];

  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      control-center-width = 380;
      notification-window-width = 380;
      timeout = 6;
      timeout-low = 4;
      timeout-critical = 0;
      fit-to-screen = true;
      cssPriority = "user";
      widgets = [ "title" "dnd" "notifications" ];
      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        dnd.text = "Do Not Disturb";
      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font Mono", Roboto, Helvetica, Arial, sans-serif;
        font-size: 13px;
      }

      .control-center {
        background: rgba(26, 27, 38, 0.95);
        color: #c0caf5;
        border: 1px solid #7aa2f7;
        border-radius: 12px;
        margin: 8px;
        padding: 8px;
      }

      .control-center-list {
        background: transparent;
      }

      .notification-row {
        background: transparent;
        margin: 4px 0;
      }

      .notification-background .notification,
      .floating-notifications .notification {
        background: #1a1b26;
        color: #c0caf5;
        border: 1px solid rgba(122, 162, 247, 0.4);
        border-radius: 8px;
        margin: 4px;
        padding: 8px;
      }

      .notification.critical,
      .notification-row.critical .notification {
        border-color: #f7768e;
      }

      .notification .summary {
        color: #bb9af7;
        font-weight: bold;
      }

      .notification .body {
        color: #c0caf5;
      }

      .notification .close-button {
        background: transparent;
        color: #f7768e;
        border: none;
      }

      .notification .close-button:hover {
        background: rgba(247, 118, 142, 0.2);
      }

      .control-center .notification-row .close-button {
        background: transparent;
        color: #f7768e;
      }

      .widget-title {
        color: #e0af68;
        font-weight: bold;
        margin: 4px 8px;
      }

      .widget-title button {
        background: rgba(187, 154, 247, 0.2);
        color: #bb9af7;
        border: none;
        border-radius: 6px;
        padding: 2px 8px;
      }

      .widget-dnd {
        color: #c0caf5;
        margin: 4px 8px;
      }

      .widget-dnd > switch {
        background: rgba(255, 255, 255, 0.1);
        border-radius: 12px;
      }

      .widget-dnd > switch:checked {
        background: #9ece6a;
      }
    '';
  };
}
