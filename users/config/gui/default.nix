{ pkgs, ... }:
{
  imports = [
    ./cursor.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprmon.nix
    ./hyprpaper.nix
    ./hyprshell.nix
    ./keyring.nix
    ./kitty.nix
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
