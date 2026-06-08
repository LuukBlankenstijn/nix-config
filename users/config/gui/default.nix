{ osConfig, lib, ... }:
{
  imports = [
    ./cursor.nix
    ./ghostty.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprmon.nix
    ./hyprpaper.nix
    ./hyprpicker.nix
    ./hyprshell.nix
    ./keyring.nix
    ./nautilus.nix
    ./pyprland.nix
    ./styling.nix
    ./swaync.nix
    ./tailscale.nix
    ./thunderbird.nix
    ./waybar.nix
    ./winapps.nix
    ./zen-browser.nix
  ];

  home.packages = lib.optionals osConfig.cfg.userConfig.desktop.enable osConfig.cfg.userConfig.extraPackages;
}
