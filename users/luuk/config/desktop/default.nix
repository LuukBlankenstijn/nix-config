{ ... }: {
  imports = [
    ./cursor.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./hyprshell.nix
    ./kitty.nix
    ./ssh-client.nix
    ./styling.nix
    ./waybar.nix
    ./zen-browser.nix

    ../shared
  ];
}
