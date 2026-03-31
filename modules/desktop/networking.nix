{ config, lib, ... }:
lib.mkIf config.cfg.networking.enable {
  networking = {
    dhcpcd.enable = false;

    networkmanager = {
      enable = true;
      wifi = {
        powersave = false;
        backend = "iwd";
      };
    };

    wireless.iwd = {
      enable = true;
      settings = {
        General = {
          EnableNetworkConfiguration = true;
          RoamThreshold = -70;
          RoamThreshold5G = -76;
        };
        Network = {
          EnableIPv6 = true;
          RoutePriorityOffset = 300;
        };
        Scan = {
          DisablePeriodicScan = false;
        };
      };
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  environment.persistence."/persist".directories = lib.mkIf config.cfg.impermanence.enable [
    "/etc/NetworkManager/system-connections"
    "/var/lib/iwd"
  ];
}
