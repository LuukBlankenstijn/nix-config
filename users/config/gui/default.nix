{ osConfig, lib, ... }:
let
  niri = osConfig.cfg.userConfig.desktop.niri;
in
{
  imports = [
    ./cursor.nix
    ./ghostty.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./displays.nix
    ./hyprpaper.nix
    ./hyprpicker.nix
    ./hyprshell.nix
    ./keyring.nix
    ./nautilus.nix
    ./pinned-apps.nix
    ./pyprland.nix
    ./styling.nix
    ./swaync.nix
    ./tailscale.nix
    ./thunderbird.nix
    ./waybar.nix
    ./winapps.nix
    ./zen-browser.nix
  ]
  ++ lib.optionals niri.enable ([ ./niri.nix ] ++ lib.optional niri.noctalia.enable ./noctalia.nix);

  home.packages = lib.optionals osConfig.cfg.userConfig.desktop.enable osConfig.cfg.userConfig.extraPackages;
}
