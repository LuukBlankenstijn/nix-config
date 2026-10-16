{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib)
    mkIf
    mapAttrs'
    nameValuePair
    filterAttrs
    any
    attrValues
    ;
  nbSshProfiles = filterAttrs (_: p: p.ssh.enable) config.cfg.networking.netbird.profiles;
  nbSshEnabled = config.cfg.networking.netbird.enable && nbSshProfiles != { };
in
{
  config = mkIf nbSshEnabled {
    assertions = [
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

    environment.systemPackages = [ pkgs.waypipe ];

    users.users.${config.cfg.user}.openssh.authorizedKeys.keyFiles = [
      inputs.ssh-keys.outPath
    ];

    networking.firewall.interfaces = mapAttrs' (
      profileName: _: nameValuePair "nb-${profileName}" { allowedTCPPorts = [ 22 ]; }
    ) nbSshProfiles;
  };
}
