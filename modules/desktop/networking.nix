{ config, lib, ... }:
lib.mkIf config.cfg.networking.enable {
  # facter auto-populates networking.interfaces.<iface>.useDHCP, which generates
  # network-addresses-<iface>.service bound to the device unit and stalls boot
  # for up to 90s when the wlan device is slow. NetworkManager handles DHCP.
  hardware.facter.detected.dhcp.enable = lib.mkDefault false;

  networking = {
    dhcpcd.enable = false;
    useDHCP = false;

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
    directories = [
      "/etc/NetworkManager/system-connections"
    ]
    ++ lib.optionals config.cfg.networking.wifi.enable [ "/var/lib/iwd" ];
  };
}
