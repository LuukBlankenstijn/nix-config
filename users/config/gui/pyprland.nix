{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  scratchpad =
    name: geometry:
    let
      app = config.desktop.pinnedApps.${name};
    in
    geometry
    // {
      command = lib.escapeShellArgs app.command;
      class = app.appId;
    };
in
lib.mkIf
  (
    osConfig.cfg.userConfig.desktop.hyprland.enable
    && osConfig.cfg.userConfig.desktop.hyprland.pyprland.enable
  )
  {
    home.packages = [ pkgs.pyprland ];

    xdg.configFile."pypr/config.toml".source = (pkgs.formats.toml { }).generate "pyprland-config" {
      pyprland.plugins = [ "scratchpads" ];
      scratchpads = {
        term = {
          command = "${pkgs.ghostty}/bin/ghostty --class=pypr.ghostty";
          animation = "fromTop";
          unfocus = "hide";
          position = "2% 3%";
          size = "96% 94%";
          class = "pypr.ghostty";
          hide_delay = 0;
        };
        whatsapp = scratchpad "whatsapp" {
          animation = "fromRight";
          position = "39% 3%";
          size = "60% 96%";
          excludes = [ "signal" ];
        };
        signal = scratchpad "signal" {
          animation = "fromRight";
          position = "39% 3%";
          size = "60% 96%";
          excludes = [ "whatsapp" ];
        };
      };
    };

    wayland.windowManager.hyprland.settings = {
      on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''
              function()
                hl.exec_cmd("pypr")
              end
            '')
          ];
        }
      ];

      bind =
        builtins.map
          (b: {
            _args = [
              (lib.generators.mkLuaInline ''mainmod .. " + ${b.key}"'')
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pypr toggle ${b.target}")'')
            ];
          })
          [
            {
              key = "Z";
              target = "term";
            }
            {
              key = "W";
              target = "whatsapp";
            }
            {
              key = "S";
              target = "signal";
            }
          ];
    };
  }
