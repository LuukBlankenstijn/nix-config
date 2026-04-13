{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.cfg.networking.netbird.enable {
    services.netbird = {
      ui.enable = true;
      clients.default = {
        name = "netbird";
        port = 51820;
      };
    };

    environment.persistence."/persist" = lib.mkIf config.cfg.impermanence.enable {
      directories = [
        "/var/lib/netbird"
      ];
    };
  };
}
