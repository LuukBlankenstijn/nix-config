{ config, lib, ... }:
let
  cfg = config.cfg.networking.tailscale;
in
{
  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      extraSetFlags = [ "--operator=${config.cfg.user}" ];
      extraUpFlags = lib.optional (cfg.loginServer != null) "--login-server=${cfg.loginServer}";
    };

    environment.persistence."/persist" = lib.mkIf config.cfg.impermanence.enable {
      directories = [ "/var/lib/tailscale" ];
    };
  };
}
