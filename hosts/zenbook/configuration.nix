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
        ssh.enable = true;
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
        wallpaper = ../../assets/wallpapers/mountain-sunrise.jpg;
        hyprland = {
          enable = true;
          idle.enable = true;
          lock = {
            enable = true;
            wallpaper = ./../../assets/wallpapers/dreamy-night-landscape-mh.jpg;
          };
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
        browser = {
          enable = true;
          containers = {
            m-account = {
              color = "green";
              id = 1;
            };
            a-account = {
              color = "red";
              id = 2;
            };
          };
          extensions = [
            "bitwarden"
            "multi-account-containers"
          ];
        };
        email.enable = true;
        bluetooth.enable = true;
        tailscale.enable = true;

        winapps.enable = true;
      };

      git.enable = true;
      neovim.enable = true;
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
        gh
      ];

      extraGroups = [ "dialout" ];

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

  networking.hostId = "6bbc35ad";
}
