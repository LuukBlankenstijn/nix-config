{ config, lib, inputs, ... }:
let
  inherit (lib) mkIf mapAttrs' nameValuePair filterAttrs any attrValues;
  tsSsh = config.cfg.networking.tailscale.ssh;
  nbSshProfiles = filterAttrs (_: p: p.ssh.enable) config.cfg.networking.netbird.profiles;
  nbSshEnabled = config.cfg.networking.netbird.enable && nbSshProfiles != { };
in
{
  config = mkIf (tsSsh.enable || nbSshEnabled) {
    assertions = [
      {
        assertion = tsSsh.enable -> config.cfg.networking.tailscale.enable;
        message = "cfg.networking.tailscale.ssh.enable requires cfg.networking.tailscale.enable";
      }
      {
        assertion =
          (any (p: p.ssh.enable) (attrValues config.cfg.networking.netbird.profiles))
          -> config.cfg.networking.netbird.enable;
        message = "cfg.networking.netbird.profiles.<name>.ssh.enable requires cfg.networking.netbird.enable";
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

    networking.firewall.interfaces =
      (lib.optionalAttrs tsSsh.enable { "tailscale0".allowedTCPPorts = [ 22 ]; })
      // (mapAttrs' (profileName: _: nameValuePair "nb-${profileName}" { allowedTCPPorts = [ 22 ]; }) nbSshProfiles);
  };
}
