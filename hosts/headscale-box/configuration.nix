{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  cfg = {
    server.enable = true;
    networking = {
      tailscale.enable = true;
      netbird = {
        enable = true;
        managementUrl = "https://netbird.luukblankenstijn.nl";
        setupKey.enable = true;
      };
    };
    services.headscale.enable = true;
    services.traefik.enable = true;

    users.luuk = {
      git.enable = true;
      neovim.enable = true;
      shell.enable = true;
      clipboard.enable = true;
    };
  };

  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = false;

  boot.loader.grub = {
    enable = true;
    efiSupport = false;
    device = "/dev/sda";
  };

  system.stateVersion = "25.05";
}
