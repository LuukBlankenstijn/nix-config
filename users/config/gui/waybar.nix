{
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  notifEnabled = osConfig.cfg.userConfig.desktop.notifications.enable;
in
lib.mkIf (osConfig.cfg.userConfig.desktop.enable && osConfig.cfg.userConfig.desktop.waybar.enable) (
  lib.mkMerge [
    {
      programs.waybar = {
        enable = true;
        systemd.enable = true;

        settings = [
          (
            {
              layer = "top";
              position = "top";
              margin-top = 0;
              margin-left = 0;
              margin-right = 0;
              spacing = 4;

              modules-left = [
                "hyprland/workspaces"
                "hyprland/window"
              ];
              modules-center = [ "clock" ];
              modules-right = [
                "pulseaudio"
                "bluetooth"
                "network"
                "battery"
              ]
              ++ lib.optional notifEnabled "custom/notification"
              ++ [ "tray" ];

              "hyprland/workspaces" = {
                format = "{name}";
                on-click = "activate";
              };

              "hyprland/window" = {
                format = "{class}";
                icon = true;
              };

              "clock" = {
                interval = 1;
                format = "{:%I:%M:%S %p  |  %a, %b %e}";
                tooltip-format = "<tt><small>{calendar}</small></tt>";
              };

              "network" = {
                interval = 1;
                format-wifi = " {essid}";
                format-ethernet = "󰈀";
                format-disconnected = "󰖪";
                tooltip-format = "{essid} ({signalStrength}%)  {bandwidthDownBits}  {bandwidthUpBits}";
                on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
              };

              "bluetooth" = {
                format = "";
                format-connected = " {num_connections}";
                tooltip-format = ''
                  {controller_alias}	{controller_address}

                  {num_connections} connected'';
                tooltip-format-connected = ''
                  {controller_alias}	{controller_address}

                  {num_connections} connected

                  {device_enumerate}'';
                tooltip-format-enumerate-connected = "{device_alias}	{device_address}";
                on-click = "${pkgs.overskride}/bin/overskride";
              };

              pulseaudio = {
                format = "{icon} {volume}%";
                format-muted = "󰝟";
                format-icons = {
                  headphone = "";
                  hands-free = "󱡒";
                  headset = "󰋎";
                  phone = "";
                  portable = "";
                  car = "";
                  default = [
                    "󰕿"
                    "󰖀"
                    "󰕾"
                  ];
                };
                on-click = "${pkgs.pwvucontrol}/bin/pwvucontrol";
              };

              "battery" = {
                states = {
                  "warning" = 30;
                  "critical" = 15;
                };
                format = "{icon} {capacity}%";
                format-icons = [
                  ""
                  ""
                  ""
                  ""
                  ""
                ];
              };
            }
            // lib.optionalAttrs notifEnabled {
              "custom/notification" = {
              tooltip = false;
              format = " {}";
              format-icons = {
                notification              = "";
                none                      = "";
                dnd-notification          = "";
                dnd-none                  = "";
                inhibited-notification    = "";
                inhibited-none            = "";
                dnd-inhibited-notification = "";
                dnd-inhibited-none        = "";
              };
              return-type = "json";
              exec-if = "which swaync-client";
              exec = "swaync-client -swb";
              on-click = "swaync-client -t -sw";
              on-click-right = "swaync-client -d -sw";
              escape = true;
            };
            }
          )
        ];

        style = ''
          * {
              font-family: "JetBrainsMono Nerd Font Mono", Roboto, Helvetica, Arial, sans-serif;
              font-size: 13px;
              border: none;
              border-radius: 0;
          }

          window#waybar {
              background-color: rgba(26, 27, 38, 0.8);
              border-radius: 0;
              color: #ffffff;
              transition-property: background-color;
              transition-duration: .5s;
          }

          #workspaces button {
              padding: 0 5px;
              color: #7aa2f7;
          }

          #workspaces button.active {
              color: #bb9af7;
              border-bottom: 2px solid #bb9af7;
          }

          #clock, #cpu, #memory, #battery, #pulseaudio, #network, #bluetooth, #tray, #custom-notification {
              padding: 0 12px;
              margin: 4px 2px;
              border-radius: 8px;
              background-color: rgba(255, 255, 255, 0.1);
          }

          #custom-notification.notification,
          #custom-notification.inhibited-notification { color: #f7768e; }
          #custom-notification.dnd-none,
          #custom-notification.dnd-inhibited-none { color: #565f89; }
          #custom-notification.dnd-notification,
          #custom-notification.dnd-inhibited-notification { color: #bb9af7; }

          #clock {
              color: #e0af68;
              background: transparent;
          }

          #pulseaudio { color: #9ece6a; }
          #network { color: #7dcfff; }
          #cpu { color: #f7768e; }
          #battery.charging { color: #9ece6a; }
          #battery.critical:not(.charging) {
              color: #f7768e;
              animation-name: blink;
              animation-duration: 0.5s;
              animation-timing-function: linear;
              animation-iteration-count: infinite;
              animation-direction: alternate;
          }

          @keyframes blink {
              to { background-color: #f7768e; color: #ffffff; }
          }
        '';
      };

      fonts.fontconfig.enable = true;
      home.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        pwvucontrol
        overskride
        networkmanagerapplet
      ];
    }

    (lib.mkIf osConfig.cfg.userConfig.desktop.hyprland.enable {
      wayland.windowManager.hyprland.settings.window_rule =
        let
          classRegex = "(com.saivert.pwvucontrol|io.github.kaii_lb.Overskride|nm-connection-editor|.blueman-manager-wrapped|xdg-desktop-portal-gtk)";
        in
        [
          {
            match.class = classRegex;
            float = true;
          }
          {
            match.class = classRegex;
            size = "monitor_w*0.7 monitor_h*0.7";
          }
          {
            match.class = classRegex;
            move = "monitor_w*0.15 monitor_h*0.15";
          }
        ];
    })
  ]
)
