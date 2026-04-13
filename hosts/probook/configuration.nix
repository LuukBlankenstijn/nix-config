{ pkgs, ... }:
{
  imports = [
    ./disko.nix
    ../../modules
    { hardware.facter.reportPath = ./facter.json; }
  ];

  cfg = {
    impermanence.enable = true;

    desktop.enable = true;
    desktop.displayManager.enable = true;
    desktop.audio.enable = true;
    desktop.hardware.enable = true;

    bluetooth.enable = true;
    networking = {
      enable = true;
      wifi.enable = true;
      tailscale.enable = true;
    };
    laptop.enable = true;
    virtualisation.docker.enable = true;
    virtualisation.libvirtd.enable = true;
    virtualisation.virtManager.enable = true;

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

        winapps.enable = false;
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

      work.enable = true;
      gewis.enable = true;
    };
  };
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.11";

  networking.hostName = "probook";
  networking.hostId = "6bbc35ad";
}
