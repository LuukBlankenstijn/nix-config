{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkForce mkMerge;
  cfg = config.cfg.services.alloy;
  bao = cfg.openbao;
  agentName = "alloy-tls";
  agentUnit = "vault-agent-${agentName}.service";
  credentialSecrets = [
    "openbao/role-id"
    "openbao/secret-id"
  ];
  tlsDir = builtins.dirOf cfg.tls.certFile;
  tlsConfig = ''
    tls_config {
          ca_file   = "${cfg.tls.caFile}"
          cert_file = "${cfg.tls.certFile}"
          key_file  = "${cfg.tls.keyFile}"
        }'';
  hostLabels = ''external_labels = { host = "${config.networking.hostName}" }'';
in
{
  config = mkIf cfg.enable (mkMerge [
    {
      services.alloy.enable = true;

      environment.etc."alloy/config.alloy".text = ''
        prometheus.exporter.unix "host" { }

        prometheus.scrape "host" {
          targets    = prometheus.exporter.unix.host.targets
          forward_to = [prometheus.remote_write.mimir.receiver]
        }

        prometheus.remote_write "mimir" {
          ${hostLabels}

          endpoint {
            url = "${cfg.metricsUrl}"

            ${tlsConfig}
          }
        }

        loki.relabel "journal" {
          forward_to = []

          rule {
            source_labels = ["__journal__systemd_unit"]
            target_label  = "unit"
          }

          rule {
            source_labels = ["__journal_priority_keyword"]
            target_label  = "level"
          }
        }

        loki.source.journal "journal" {
          max_age       = "12h"
          labels        = { job = "systemd-journal" }
          relabel_rules = loki.relabel.journal.rules
          forward_to    = [loki.write.loki.receiver]
        }

        loki.write "loki" {
          ${hostLabels}

          endpoint {
            url = "${cfg.logsUrl}"

            ${tlsConfig}
          }
        }
      '';

      users.users.alloy = {
        isSystemUser = true;
        group = "alloy";
      };
      users.groups.alloy = { };

      systemd.services.alloy.serviceConfig = {
        DynamicUser = mkForce false;
        User = "alloy";
        Group = "alloy";
      };

      systemd.tmpfiles.rules = [ "d ${tlsDir} 0750 root alloy -" ];

      environment.persistence."/persist" = mkIf config.cfg.impermanence.enable {
        directories = [ "/var/lib/alloy" ];
      };
    }

    (mkIf bao.enable {
      sops.secrets = lib.genAttrs credentialSecrets (_: {
        sopsFile = bao.secretsFile;
        restartUnits = [ agentUnit ];
      });

      services.vault-agent.instances.${agentName} = {
        package = pkgs.openbao;
        settings = {
          vault.address = bao.address;

          auto_auth.method = [
            {
              type = "approle";
              config = {
                role_id_file_path = config.sops.secrets."openbao/role-id".path;
                secret_id_file_path = config.sops.secrets."openbao/secret-id".path;
                remove_secret_id_file_after_reading = false;
              };
            }
          ];

          template = [
            {
              destination = "/run/vault-agent/${agentName}.rendered";
              contents = ''
                {{- with pkiCert "${bao.pkiIssuePath}" "common_name=${bao.commonName}" -}}
                {{ .Key | writeToFile "${cfg.tls.keyFile}" "root" "alloy" "0640" }}
                {{ .CA | writeToFile "${cfg.tls.caFile}" "root" "alloy" "0640" }}
                {{ .Cert | writeToFile "${cfg.tls.certFile}" "root" "alloy" "0640" }}
                {{- end -}}
              '';
            }
          ];
        };
      };
    })
  ]);
}
