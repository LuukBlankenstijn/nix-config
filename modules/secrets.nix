{ config, ... }:
{
  sops = {
    age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/home/${config.cfg.user}/.ssh/id_ed25519"
    ];
    defaultSopsFile = config.cfg.secrets.file;
    defaultSopsFormat = "yaml";
    secrets.laptop-luuk-password.neededForUsers = true;
  };
}
