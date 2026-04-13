{ config, lib, ... }:
lib.mkIf config.cfg.networking.enable {
  networking = {
    dhcpcd.enable = false;

    networkmanager = {
      enable = true;
      wifi = {
        powersave = lib.mkDefault false;
        backend = lib.mkIf config.cfg.networking.wifi.enable "iwd";
      };
    };

    wireless.iwd = lib.mkIf config.cfg.networking.wifi.enable {
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

  environment.persistence."/persist" = lib.mkIf config.cfg.impermanence.enable {
    directories =
      [ "/etc/NetworkManager/system-connections" ]
      ++ lib.optionals config.cfg.networking.wifi.enable [ "/var/lib/iwd" ];
  };
}
