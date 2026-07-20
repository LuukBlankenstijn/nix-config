{ pkgs, ... }:
{
  imports = [
    ./disko.nix
    ../../modules
    { hardware.facter.reportPath = ./facter.json; }
  ];

  cfg = {
    impermanence.enable = false;
    secrets.file = ../../secrets/thinkpad.yaml;
    gpg.enable = true;
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
      netbird = {
        enable = true;
        profiles.nb = {
          ssh.enable = true;
          ssh.netbirdSsh = true;
          managementUrl = "https://netbird.luukblankenstijn.nl";
        };
      };
    };
    laptop.enable = true;
    virtualisation = {
      podman.enable = true;
      docker.enable = true;
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
          displays.enable = true;
          pyprland.enable = true;
        };

        cursor.enable = true;
        nautilus.enable = true;
        styling.enable = true;
        waybar.enable = true;
        keyring.enable = true;
        notifications.enable = true;

        terminal.enable = true;
        browser = {
          enable = true;
          containers = {
            work = {
              color = "blue";
              id = 1;
            };
          };
          extensions = [
            "onepassword-password-manager"
            "multi-account-containers"
            "bitwarden"
          ];
        };
        bluetooth.enable = true;
      };

      git = {
        enable = true;
        dirSettings."gitdir:~/code/" = {
          user = {
            email = "luuk@dutchcodingcompany.com";
            signingkey = "~/.ssh/id_ed25519";
          };
          gpg.format = "ssh";
          commit.gpgsign = true;
          tag.gpgsign = true;
        };
      };
      neovim.enable = true;
      omp.enable = true;
      shell.enable = true;
      clipboard = {
        enable = true;
        history.enable = true;
      };

      extraPackages = with pkgs; [
        spotify
        signal-desktop
        gnome-calculator
        slack
        _1password-gui
        github-copilot-cli
        python3
        glab
        claude-code
      ];

      extraGroups = [ "dialout" ];
    };
  };
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 20;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.11";

  networking.hostId = "8b7f06be";
}
