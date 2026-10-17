{ config, lib, ... }:
let
  inherit (lib) mkIf mkForce;
  cfg = config.cfg.services.alloy;
  cert = config.cfg.deviceCert;
  tlsConfig = ''
    tls_config {
          ca_file   = "/etc/ssl/certs/ca-certificates.crt"
          cert_file = "${cert.certFile}"
          key_file  = "${cert.keyFile}"
        }'';
  hostLabels = ''external_labels = { host = "${config.networking.hostName}" }'';
  extraScrapes = lib.concatStrings (
    lib.mapAttrsToList (job: address: ''
      prometheus.scrape "${lib.replaceStrings [ "-" ] [ "_" ] job}" {
        targets    = [{ __address__ = "${address}", job = "${job}" }]
        forward_to = [prometheus.remote_write.mimir.receiver]
      }

    '') cfg.scrapeTargets
  );
in
{
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cert.enable;
        message = "cfg.services.alloy authenticates to Loki and Mimir with the device certificate; enable cfg.deviceCert.";
      }
    ];

    services.alloy.enable = true;

    environment.etc."alloy/config.alloy".text = ''
      prometheus.exporter.unix "host" { }

      discovery.relabel "host" {
        targets = prometheus.exporter.unix.host.targets

        rule {
          target_label = "job"
          replacement  = "node-exporter"
        }
      }

      prometheus.scrape "host" {
        targets    = discovery.relabel.host.output
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
    ''
    + extraScrapes;

    users.users.alloy = {
      isSystemUser = true;
      group = "alloy";
      extraGroups = [ cert.group ];
    };
    users.groups.alloy = { };

    systemd.services.alloy = {
      startLimitIntervalSec = 0;
      serviceConfig = {
        DynamicUser = mkForce false;
        User = "alloy";
        Group = "alloy";
      };
    };

    environment.persistence."/persist" = mkIf config.cfg.impermanence.enable {
      directories = [ "/var/lib/alloy" ];
    };
  };
}
