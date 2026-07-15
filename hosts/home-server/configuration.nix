{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  cfg = {
    server.enable = true;
    networking = {
      tailscale = {
        enable = true;
        loginServer = "https://headscale.luukblankenstijn.nl";
      };
      netbird = {
        enable = true;
        profiles.netbird = {
          managementUrl = "https://netbird.luukblankenstijn.nl";
          ssh.enable = true;
          ssh.netbirdSsh = true;
          setupKey.enable = true;
        };
      };
    };
    services.k3s = {
      enable = true;
      gpu.enable = true;
    };

    users.luuk = {
      git.enable = true;
      neovim.enable = true;
      shell.enable = true;
      clipboard.enable = true;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    IdleAction = "ignore";
  };

  systemd.sleep.settings.Sleep = {
    AllowSuspend = "no";
    AllowHibernation = "no";
    AllowHybridSleep = "no";
    AllowSuspendThenHibernate = "no";
  };

  boot.kernel.sysctl."net.ipv6.conf.enp3s0.disable_ipv6" = 1;
  networking.dhcpcd.extraConfig = "noipv6rs";

  environment.etc."k3s-resolv.conf".text = ''
    nameserver 1.1.1.1
    nameserver 8.8.8.8
  '';
  services.k3s.extraFlags = [ "--resolv-conf=/etc/k3s-resolv.conf" ];

  system.stateVersion = "25.05";
}
