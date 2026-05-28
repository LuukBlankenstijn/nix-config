{ osConfig, lib, pkgs, ... }:
lib.mkIf (osConfig.cfg.userConfig.desktop.hyprland.enable && osConfig.cfg.userConfig.desktop.hyprland.pyprland.enable) {
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
      whatsapp = {
        # use x11 because wayland does not allow setting class
        command = "${pkgs.chromium}/bin/chromium --app=https://web.whatsapp.com --class=pypr-whatsapp --user-data-dir=$HOME/.cache/pypr/whatsapp --ozone-platform=x11";
        animation = "fromRight";
        position = "39% 3%";
        size = "60% 96%";
        class = "pypr-whatsapp";
        excludes = [ "signal" ];
      };
      signal = {
        command = "${pkgs.signal-desktop}/bin/signal-desktop";
        animation = "fromRight";
        position = "39% 3%";
        size = "60% 96%";
        class = "signal";
        excludes = [ "whatsapp" ];
      };
      spotify = {
        command = "${pkgs.spotify}/bin/spotify";
        animation = "fromTop";
        position = "2% 3%";
        size = "96% 94%";
        class = "spotify";
        unfocus = "hide";
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

    bind = builtins.map
      (b: {
        _args = [
          (lib.generators.mkLuaInline ''mainmod .. " + ${b.key}"'')
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pypr toggle ${b.target}")'')
        ];
      })
      [
        { key = "Z"; target = "term"; }
        { key = "W"; target = "whatsapp"; }
        { key = "S"; target = "signal"; }
        { key = "D"; target = "spotify"; }
      ];
  };
}
