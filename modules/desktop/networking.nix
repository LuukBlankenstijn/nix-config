_: {
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

  environment.persistence."/persist".directories = [
    "/etc/NetworkManager/system-connections"
    "/var/lib/iwd"
  ];
}
