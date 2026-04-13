{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.cfg.networking.tailscale.enable {
    services.tailscale = {
      enable = true;
      extraSetFlags = [ "--operator=${config.cfg.user}" ];
      extraUpFlags = lib.optional (config.cfg.networking.tailscale.loginServer != null) "--login-server=${config.cfg.networking.tailscale.loginServer}";
    };

    environment.persistence."/persist" = lib.mkIf config.cfg.impermanence.enable {
      directories = [
        "/var/lib/tailscale"
      ];
    };
  };
}
