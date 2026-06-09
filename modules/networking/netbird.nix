{ config, lib, ... }:
let
  inherit (lib) mkIf optionalAttrs;
  cfg = config.cfg.networking.netbird;
in
{
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.setupKey.enable -> cfg.enable;
        message = "cfg.networking.netbird.setupKey.enable requires cfg.networking.netbird.enable";
      }
    ];

    sops.secrets = mkIf cfg.setupKey.enable {
      netbird-setupkey.mode = "0400";
    };

    services.netbird = {
      ui.enable = true;
      clients.default = {
        name = "netbird";
        port = 51820;
        environment = optionalAttrs (cfg.managementUrl != null) {
          NB_MANAGEMENT_URL = cfg.managementUrl;
        };
        login = mkIf cfg.setupKey.enable {
          enable = true;
          setupKeyFile = config.sops.secrets.netbird-setupkey.path;
          systemdDependencies = [ "sops-install-secrets.service" ];
        };
      };
    };

    services.resolved.enable = true;

    users.users.${config.cfg.user}.extraGroups = [ "netbird" ];

    environment.persistence."/persist" = lib.mkIf config.cfg.impermanence.enable {
      directories = [
        "/var/lib/netbird"
      ];
    };
  };
}
