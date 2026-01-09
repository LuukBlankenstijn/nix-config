{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = [
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
          "tray"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
        };

        "hyprland/window" = {
          format = "{class}";
          icon = true;
        };

        "clock" = {
          format = "{:%I:%M %p  |  %a, %b %e}";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };

        "network" = {
          format-wifi = " ";
          format-ethernet = "󰈀";
          format-disconnected = "󰖪";
          tooltip-format = "{essid} ({signalStrength}%)";
          on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
        };

        "bluetooth" = {
          format = "";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
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

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
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
    ];

    style = ''
      * {
          font-family: "JetBrainsMono Nerd Font", Roboto, Helvetica, Arial, sans-serif;
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

      #clock, #cpu, #memory, #battery, #pulseaudio, #network, #tray {
          padding: 0 12px;
          margin: 4px 2px;
          border-radius: 8px;
          background-color: rgba(255, 255, 255, 0.1);
      }

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

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    pwvucontrol
    overskride
    networkmanagerapplet
  ];

  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "float, class:(pwvucontrol|overskride|nm-connection-editor)"
      "move 55 50, class:(pwvucontrol|overskride|nm-connection-editor)"
    ];
  };
}
