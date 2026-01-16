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
    ./hyprshell.nix
    ./keyring.nix
    ./pyprland.nix
    ./styling.nix
    ./tailscale.nix
    ./waybar.nix
    ./zen-browser.nix
  ];

  home.packages = with pkgs; [
    signal-desktop
    discord
    eduvpn-client
    gnome-calculator
    nautilus
    jetbrains.datagrip
    spotify
  ];
}
