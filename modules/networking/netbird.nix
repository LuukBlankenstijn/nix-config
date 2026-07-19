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
  setupKeyProfiles = filterAttrs (_: p: p.setupKey.enable) cfg.profiles;
  netbirdSshEnabled = lib.any (p: p.ssh.netbirdSsh) (lib.attrValues cfg.profiles);
in
{
  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = cfg.enable || !netbirdSshEnabled;
          message = "cfg.networking.netbird.profiles.<name>.ssh.netbirdSsh requires cfg.networking.netbird.enable";
        }
      ];
    }

    (mkIf cfg.enable {
      sops.secrets = mapAttrs' (
        profileName: p:
        nameValuePair p.setupKey.secretName {
          mode = "0400";
          # The login unit runs with RemainAfterExit=true, so it never re-applies
          # the setup key on its own. Restart it whenever the secret changes.
          restartUnits = [ "${config.services.netbird.clients.${profileName}.service.name}-login.service" ];
        }
      ) setupKeyProfiles;

      services.netbird = {
        ui.enable = true;
        clients = mapAttrs (profileName: p: {
          name = profileName;
          port = p.port;
          hardened = mkIf p.ssh.netbirdSsh false;
          config = mkIf p.ssh.netbirdSsh { ServerSSHAllowed = true; };
          environment = optionalAttrs (p.managementUrl != null) {
            NB_MANAGEMENT_URL = p.managementUrl;
          };
          login = mkIf p.setupKey.enable {
            enable = true;
            setupKeyFile = config.sops.secrets.${p.setupKey.secretName}.path;
          };
        }) cfg.profiles;
      };

      services.resolved.enable = true;

      programs.ssh.extraConfig = lib.mkIf netbirdSshEnabled ''
        Include /etc/ssh/ssh_config.d/99-netbird.conf
      '';

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
