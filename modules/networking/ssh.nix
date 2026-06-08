{ config, lib, inputs, ... }:
let
  inherit (lib) mkIf;
  tsSsh = config.cfg.networking.tailscale.ssh;
  nbSsh = config.cfg.networking.netbird.ssh;
in
{
  config = mkIf (tsSsh.enable || nbSsh.enable) {
    assertions = [
      {
        assertion = tsSsh.enable -> config.cfg.networking.tailscale.enable;
        message = "cfg.networking.tailscale.ssh.enable requires cfg.networking.tailscale.enable";
      }
      {
        assertion = nbSsh.enable -> config.cfg.networking.netbird.enable;
        message = "cfg.networking.netbird.ssh.enable requires cfg.networking.netbird.enable";
      }
    ];

    services.openssh = {
      enable = true;
      openFirewall = false;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    users.users.${config.cfg.user}.openssh.authorizedKeys.keyFiles = [
      inputs.ssh-keys.outPath
    ];

    networking.firewall.interfaces."tailscale0".allowedTCPPorts = mkIf tsSsh.enable [ 22 ];
    networking.firewall.interfaces."nb-netbird".allowedTCPPorts = mkIf nbSsh.enable [ 22 ];
  };
}
