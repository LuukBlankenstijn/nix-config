{ ... }:
{
  imports = [
    ../common.nix
    ./hyprland.nix
    ./display-manager.nix
    ./portals.nix
    ./hardware.nix
    ./bluetooth.nix
    ./power-management.nix
    ./virtualisation.nix
    ./services.nix
    ./shell.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
