{ config, lib, ... }:
let
  persistRoot = lib.optionalString config.cfg.impermanence.enable "/persist";
in
{
  sops = {
    age.sshKeyPaths = [
      "${persistRoot}/etc/ssh/ssh_host_ed25519_key"
      "${persistRoot}/home/${config.cfg.user}/.ssh/id_ed25519"
    ];
    defaultSopsFile = config.cfg.secrets.file;
    defaultSopsFormat = "yaml";
    secrets.password.neededForUsers = true;
  };
}
