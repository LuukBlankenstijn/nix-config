{ config, lib, ... }:
let
  inherit (lib) mkIf;
  configDir = config.services.home-assistant.configDir;
  uiManagedFiles = [
    "automations.yaml"
    "scenes.yaml"
    "scripts.yaml"
  ];
in
{
  config = mkIf config.cfg.services.home-assistant.enable {
    services.home-assistant = {
      enable = true;
      config = {
        default_config = { };
        "automation ui" = "!include automations.yaml";
        "scene ui" = "!include scenes.yaml";
        "script ui" = "!include scripts.yaml";
      };
    };

    systemd.tmpfiles.rules = map (file: "f ${configDir}/${file} 0644 hass hass") uiManagedFiles;

    networking.firewall.allowedTCPPorts = [ 8123 ];

    environment.persistence."/persist" = mkIf config.cfg.impermanence.enable {
      directories = [ configDir ];
    };
  };
}
