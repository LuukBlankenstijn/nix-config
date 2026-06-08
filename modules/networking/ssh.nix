{ config, lib, inputs, ... }:
let
  inherit (lib) mkIf;
  cfg = config.cfg.networking.tailscale.ssh;
in
{
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.cfg.networking.tailscale.enable;
        message = "cfg.networking.tailscale.ssh.enable requires cfg.networking.tailscale.enable";
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

    networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 22 ];
    networking.firewall.interfaces."nb-netbird".allowedTCPPorts = mkIf config.cfg.networking.netbird.enable [ 22 ];
  };
}
