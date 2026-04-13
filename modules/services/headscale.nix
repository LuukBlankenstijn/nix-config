{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.cfg.services.headscale.enable {
    services.headscale = {
      enable = true;

      address = "127.0.0.1";
      port = 8080;

      settings = {
        server_url = "https://headscale.luukblankenstijn.nl";

        listen_addr = "127.0.0.1:8080";
        metrics_listen_addr = "127.0.0.1:9090";

        database.type = "sqlite";
        database.sqlite.path = "/var/lib/headscale/db.sqlite";

        private_key_path = "/var/lib/headscale/private.key";
        noise_private_key_path = "/var/lib/headscale/noise_private.key";

        tls_cert_path = null;
        tls_key_path = null;

        dns.base_domain = "headscale.internal.luukblankenstijn.nl";
        dns.nameservers.global = [ "1.1.1.1" "8.8.8.8" ];
      };
    };

    environment.persistence."/persist" = lib.mkIf config.cfg.impermanence.enable {
      directories = [
        "/var/lib/headscale"
      ];
    };
  };
}
