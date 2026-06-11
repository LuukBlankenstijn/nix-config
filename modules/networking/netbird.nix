{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mapAttrs
    mapAttrs'
    nameValuePair
    filterAttrs
    optionalAttrs
    ;
  cfg = config.cfg.networking.netbird;
in
{
  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = cfg.enable || !(lib.any (p: p.ssh.netbirdSsh) (lib.attrValues cfg.profiles));
          message = "cfg.networking.netbird.profiles.<name>.ssh.netbirdSsh requires cfg.networking.netbird.enable";
        }
      ];
    }

    (mkIf cfg.enable {
    services.netbird = {
      ui.enable = true;
      clients = mapAttrs (profileName: p: {
        name = profileName;
        port = p.port;
        hardened = mkIf p.ssh.netbirdSsh false;
        environment = optionalAttrs (p.managementUrl != null) {
          NB_MANAGEMENT_URL = p.managementUrl;
        };
        login = mkIf (p.setupKey.path != null) {
          enable = true;
          setupKeyFile = p.setupKey.path;
          systemdDependencies = [ "sops-install-secrets.service" ];
        };
      }) cfg.profiles;
    };

    services.resolved.enable = true;

    users.users.${config.cfg.user}.extraGroups = map (c: c.user.group) (
      lib.attrValues config.services.netbird.clients
    );

    environment.shellAliases = mapAttrs' (
      profileName: _:
      nameValuePair profileName config.services.netbird.clients.${profileName}.wrapper.meta.mainProgram
    ) (filterAttrs (n: _: n != "netbird") cfg.profiles);

    environment.persistence."/persist" = lib.mkIf config.cfg.impermanence.enable {
      directories = map (c: c.dir.state) (lib.attrValues config.services.netbird.clients);
    };
    })
  ];
}
