{ ... }:
{
  imports = [
    ../common.nix
    ./display.nix
    ./hardware.nix
    ./bluetooth.nix
    ./networking.nix
    ./power-management.nix
    ./virtualisation.nix
    ./services.nix
    ./shell.nix
    ../persistence.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
