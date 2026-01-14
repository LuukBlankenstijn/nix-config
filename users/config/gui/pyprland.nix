{ pkgs, ... }:
{
  home.packages = [ pkgs.pyprland ];

  xdg.configFile."hypr/pyprland.toml".source = (pkgs.formats.toml { }).generate "pyprland-config" {
    pyprland.plugins = [ "scratchpads" ];
    scratchpads = {
      term = {
        command = "${pkgs.kitty}/bin/kitty --class pypr-kitty";
        animation = "fromTop";
        unfocus = "hide";
        position = "2% 3%";
        size = "96% 94%";
        class = "pypr-kitty";
        hideDelay = 0;
      };
      whatsapp = {
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
        class = "Spotify";
        unfocus = "hide";
      };
    };
  };

  wayland.windowManager.hyprland.settings = {
    exec-once = [ "pypr" ];
    bind = [
      "$mainmod, Z, exec, pypr toggle term"
      "$mainmod, W, exec, pypr toggle whatsapp"
      "$mainmod, S, exec, pypr toggle signal"
      "$mainmod, D, exec, pypr toggle spotify"
    ];
  };
}
