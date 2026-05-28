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
            work = {
              color = "blue";
              id = 1;
            };
          };
          extensions = [
            "onepassword-password-manager"
            "multi-account-containers"
          ];
        };
        bluetooth.enable = true;
      };

      git = {
        enable = true;
        extraSettings = {
          user = {
            email = "luuk@dutchcodingcompany.com";
            signingkey = "60B9AA89C991A93B";
          };
          gpg.format = "openpgp";
          commit.gpgsign = true;
          tag.gpgsign = true;
          core.pager = "delta";
          interactive.diffFilter = "delta --color-only";
          delta = {
            navigate = true;
            side-by-side = true;
            line-numbers = true;
          };
          diff.tool = "difftastic";
          difftool = {
            prompt = false;
            difftastic.cmd = ''difft "$LOCAL" "$REMOTE"'';
          };
          alias.dft = "difftool";
        };
      };
      neovim.enable = true;
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
        delta
        difftastic
        python3
        glab
      ];
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
