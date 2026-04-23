{ pkgs, ... }:
{
  imports = [
    ./disko.nix
    ../../modules
    { hardware.facter.reportPath = ./facter.json; }
  ];

  cfg = {
    impermanence.enable = true;
    desktop = {
      enable = true;
      displayManager.enable = true;
      audio.enable = true;
      hardware.enable = true;
    };

    bluetooth.enable = true;
    networking = {
      enable = true;
      wifi.enable = true;
      tailscale = {
        enable = true;
        loginServer = "https://headscale.luukblankenstijn.nl";
      };
      netbird.enable = true;
    };
    laptop.enable = true;
    virtualisation = {
      docker.enable = true;
      podman.enable = true;
      libvirtd.enable = true;
      virtManager.enable = true;
    };

    users.luuk = {
      desktop = {
        enable = true;

        hyprland = {
          enable = true;
          idle.enable = true;
          lock.enable = true;
          paper.enable = true;
          shell.enable = true;
          picker.enable = true;
          mon.enable = true;
          pyprland.enable = true;
        };

        cursor.enable = true;
        nautilus.enable = true;
        styling.enable = true;
        waybar.enable = true;
        keyring.enable = true;

        terminal.enable = true;
        browser.enable = true;
        email.enable = true;
        bluetooth.enable = true;
        tailscale.enable = true;

        winapps.enable = true;
      };

      git.enable = true;
      neovim.enable = true;
      ranger.enable = true;
      rbw.enable = true;
      shell.enable = true;
      clipboard = {
        enable = true;
        history.enable = true;
      };

      extraPackages = with pkgs; [
        claude-code
        spotify
        discord
        signal-desktop
        eduvpn-client
        jetbrains.datagrip
        prismlauncher
        zotero
        gnome-calculator
        slack
      ];

      gewis.enable = true;
    };
  };
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 20;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.graphics = {
    extraPackages = [ pkgs.intel-compute-runtime ];
  };

  system.stateVersion = "25.11";

  networking.hostName = "zenbook";
  networking.hostId = "6bbc35ad";
}
