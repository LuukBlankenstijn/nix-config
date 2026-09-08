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
      displayManager = {
        enable = true;
        defaultSession = "Hyprland";
      };
      audio.enable = true;
      hardware.enable = true;
      touchscreen = {
        enable = true;
        device = "ELAN901C:00 04F3:413B";
        size = {
          width = 3840;
          height = 2400;
        };
      };
    };

    bluetooth.enable = true;
    boot.splash.enable = true;
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
          displays = {
            enable = true;
            profiles = [
              {
                name = "desk-3mon";
                output = [
                  {
                    search = "s=N9LMDW011793";
                    enable = true;
                    mode = "preferred";
                    position = "3307,1662";
                    scale = 1.25;
                  }
                  {
                    search = "s=0x00016811";
                    enable = true;
                    mode = "preferred";
                    position = "6379,830";
                    scale = 1.5;
                    transform = "270";
                  }
                  {
                    search = "n=eDP-1";
                    enable = true;
                    mode = "preferred";
                    position = "3898,3390";
                    scale = 2.0;
                  }
                ];
              }
            ];
          };
          pyprland.enable = true;
        };

        niri = {
          enable = true;
          outputs = {
            "ASUSTek COMPUTER INC VP32UQ N9LMDW011793" = {
              mode = {
                width = 3840;
                height = 2160;
              };
              scale = 1.25;
              position = {
                x = 3307;
                y = 1662;
              };
            };
            "LG Electronics LG HDR 4K 0x00016811" = {
              mode = {
                width = 3840;
                height = 2160;
              };
              scale = 1.5;
              transform.rotation = 270;
              position = {
                x = 6379;
                y = 830;
              };
            };
            "eDP-1" = {
              mode = {
                width = 3840;
                height = 2400;
                refresh = 60.0;
              };
              scale = 2.0;
              position = {
                x = 3898;
                y = 3390;
              };
            };
          };
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
      pi.enable = true;
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
