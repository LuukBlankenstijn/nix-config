{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.cfg.deviceCert;
  agentName = "device-cert";
  credentialSecrets = [
    "openbao/role_id"
    "openbao/secret_id"
  ];
  browserUsers = lib.filterAttrs (
    _: u: u.desktop.enable && u.desktop.browser.enable && u.desktop.browser.deviceCert.enable
  ) config.cfg.users;
in
{
  config = lib.mkIf cfg.enable {
    users.groups.${cfg.group} = { };

    users.users = lib.mapAttrs (_: _: { extraGroups = [ cfg.group ]; }) browserUsers;

    systemd.tmpfiles.rules = [ "d ${builtins.dirOf cfg.certFile} 0750 root ${cfg.group} -" ];

    sops.secrets = lib.genAttrs credentialSecrets (_: {
      sopsFile = cfg.secretsFile;
      restartUnits = [ "vault-agent-${agentName}.service" ];
    });

    services.vault-agent.instances.${agentName} = {
      package = pkgs.openbao;
      settings = {
        vault.address = cfg.address;

        auto_auth.method = [
          {
            type = "approle";
            config = {
              role_id_file_path = config.sops.secrets."openbao/role_id".path;
              secret_id_file_path = config.sops.secrets."openbao/secret_id".path;
              remove_secret_id_file_after_reading = false;
            };
          }
        ];

        template = [
          {
            destination = "/run/vault-agent/${agentName}.pem";
            perms = "0600";
            contents = ''
              {{- with pkiCert "${cfg.pkiIssuePath}" "common_name=${cfg.commonName}" -}}
              {{ .Cert }}{{ .Key }}
              {{ .Key | writeToFile "${cfg.keyFile}" "root" "${cfg.group}" "0640" }}
              {{ .Cert | writeToFile "${cfg.certFile}" "root" "${cfg.group}" "0640" }}
              {{- end -}}
            '';
          }
        ];
      };
    };
  };
}
