{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.desktop.pinnedApps = mkOption {
    default = { };
    description = ''
      Apps that stay running all session and want a fixed home instead of a
      place in the normal window flow. Hyprland gives them a pyprland
      scratchpad; niri gives them a named workspace.
    '';
    type = types.attrsOf (
      types.submodule {
        options = {
          command = mkOption {
            type = types.listOf types.str;
            description = "Command that starts the app, as an argument vector.";
          };

          appId = mkOption {
            type = types.str;
            description = "Wayland app id the running window reports. Find it with `niri msg windows` or `hyprctl clients`.";
          };

          workspace = mkOption {
            type = types.str;
            description = "Named niri workspace this app opens on. Apps sharing a name share the workspace.";
          };

          columnWidth = mkOption {
            type = types.nullOr types.float;
            default = null;
            example = 2.0 / 3.0;
            description = "Fraction of the screen the app's niri column opens at. Null uses the layout default.";
          };
        };
      }
    );
  };

  config.desktop.pinnedApps = {
    whatsapp = {
      command = [
        "${pkgs.chromium}/bin/chromium"
        "--app=https://web.whatsapp.com"
        "--user-data-dir=${config.xdg.cacheHome}/whatsapp"
        "--ozone-platform=wayland"
      ];
      appId = "chrome-web.whatsapp.com__-Default";
      workspace = "chat";
      columnWidth = 2.0 / 3.0;
    };

    signal = {
      command = [ "${pkgs.signal-desktop}/bin/signal-desktop" ];
      appId = "signal";
      workspace = "chat";
      columnWidth = 2.0 / 3.0;
    };
  };
}
