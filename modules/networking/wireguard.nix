{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.cfg.networking.wireguard.router.enable {
    sops.secrets.wg-router-private-key = { };
    networking.wireguard.interfaces.wg-router = {
      ips = [ "10.99.0.2/32" ];
      privateKeyFile = config.sops.secrets.wg-router-private-key.path;
      peers = [
        {
          publicKey = "FLskOFxkdENsQGYF0M4DK98isUBDp+LHeB0mJ49qxWs=";
          endpoint = "router.luukblankenstijn.nl:13231";
          allowedIPs = [
            "10.99.0.0/24"
            "10.0.32.0/24"
          ];
          persistentKeepalive = 25;
          dynamicEndpointRefreshSeconds = 300;
        }
      ];
    };
  };
}
