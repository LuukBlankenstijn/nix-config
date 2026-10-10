{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkMerge
    concatStringsSep
    attrNames
    ;
  cfg = config.cfg.networking.wireguard;
  wg-toggle = pkgs.writeShellApplication {
    name = "wg-toggle";
    runtimeInputs = [ pkgs.systemd ];
    text = ''
      interfaces=(${concatStringsSep " " (attrNames config.networking.wg-quick.interfaces)})

      if [ $# -ne 1 ]; then
        for interface in "''${interfaces[@]}"; do
          echo "$interface: $(systemctl is-active "wg-quick-$interface" || true)"
        done
        echo "usage: wg-toggle <interface>" >&2
        exit 1
      fi

      unit="wg-quick-$1"
      if systemctl is-active --quiet "$unit"; then
        systemctl stop "$unit"
        echo "$1: down"
      else
        systemctl start "$unit"
        echo "$1: up"
      fi
    '';
  };
in
{
  config = mkMerge [
    (mkIf cfg.router.enable {
      sops.secrets.wg-router-private-key = { };
      networking.wg-quick.interfaces.wg-router = {
        autostart = false;
        address = [ "10.99.0.2/32" ];
        privateKeyFile = config.sops.secrets.wg-router-private-key.path;
        peers = [
          {
            publicKey = "FLskOFxkdENsQGYF0M4DK98isUBDp+LHeB0mJ49qxWs=";
            endpoint = "router.luukblankenstijn.nl:13231";
            allowedIPs = [
              "10.99.0.0/24"
              "10.0.32.0/24"
            ];
            persistentKeepalive = 25;
          }
        ];
      };
    })

    (mkIf cfg.gewis.enable {
      sops.secrets.wg-gewis-private-key = { };
      networking.wg-quick.interfaces.wg-gewis = {
        autostart = false;
        address = [ "10.82.10.16/32" ];
        privateKeyFile = config.sops.secrets.wg-gewis-private-key.path;
        peers = [
          {
            publicKey = "/rddl3A2MyYnlvytzAVYB+ZlaoD8LF6me18xOLNnxHc=";
            endpoint = "router02.net.gewis.nl:13231";
            allowedIPs = [ "10.82.0.0/16" ];
            persistentKeepalive = 25;
          }
        ];
      };
    })

    (mkIf (cfg.router.enable || cfg.gewis.enable) {
      environment.systemPackages = [ wg-toggle ];

      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.systemd1.manage-units" &&
              /^wg-quick-.*\.service$/.test(action.lookup("unit")) &&
              ["start", "stop", "restart"].indexOf(action.lookup("verb")) >= 0 &&
              subject.isInGroup("wheel")) {
            return polkit.Result.YES;
          }
        });
      '';
    })
  ];
}
