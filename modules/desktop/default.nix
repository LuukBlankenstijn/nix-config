{ ... }:
{
  imports = [
    ../common.nix
    ./hyprland.nix
    ./niri.nix
    ./display-manager.nix
    ./fingerprint-scanner.nix
    ./portals.nix
    ./hardware.nix
    ./bluetooth.nix
    ./power-management.nix
    ./printing.nix
    ./virtualisation.nix
    ./services.nix
    ./shell.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
