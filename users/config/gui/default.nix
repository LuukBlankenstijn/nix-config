{ pkgs, ... }:
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
    ./tailscale.nix
    ./thunderbird.nix
    ./waybar.nix
    ./winapps.nix
    ./zen-browser.nix
  ];

  home.packages = with pkgs; [
    signal-desktop
    discord
    eduvpn-client
    gnome-calculator
    jetbrains.datagrip
    spotify
    zotero
  ];
}
