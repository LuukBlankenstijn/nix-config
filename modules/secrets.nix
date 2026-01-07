_: {
  sops = {
    age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/home/luuk/.ssh/id_ed25519"
    ];
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets.laptop-luuk-password.neededForUsers = true;
  };
}
