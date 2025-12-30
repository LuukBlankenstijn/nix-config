{ ... }: {
  imports = [
    ./disko.nix
    ../../modules/desktop.nix
    ../../modules/users/luuk/desktop.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.11";

  networking.hostName = "laptop";
}
