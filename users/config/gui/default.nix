{ pkgs, ... }: {
  imports = [
    ./cursor.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./hyprshell.nix
    ./kitty.nix
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
  ];
}
