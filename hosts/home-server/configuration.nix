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
      nftables.enable = true;
    };
    services.k3s.enable = true;

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

  system.stateVersion = "25.05";
}
