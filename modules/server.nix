{ config, lib, inputs, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.cfg.server.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    users.users.${config.cfg.user}.openssh.authorizedKeys.keyFiles = [
      inputs.ssh-keys.outPath
    ];

    security.sudo.wheelNeedsPassword = false;

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };
}
