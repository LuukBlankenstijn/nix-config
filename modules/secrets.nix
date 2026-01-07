_: {
  sops = {
    age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/tmp/ssh-key"
    ];
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets.laptop-luuk-password.neededForUsers = true;
  };
}
