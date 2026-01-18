{ ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  imports = [
    ./disko.nix
    ../../modules/secrets.nix
    ../../modules/desktop
    ../../modules/storage/zfs.nix
    ../../modules/users/luuk/desktop.nix
    { hardware.facter.reportPath = ./facter.json; }
  ];
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 20;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.11";

  networking.hostName = "zenbook";
  networking.hostId = "6bbc35ad";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
