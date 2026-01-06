{ config, lib, ... }: {
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" "/tmp/ssh-key" ];
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.secrets.laptop-luuk-password.neededForUsers = true;

  users.users.luuk.hashedPasswordFile =
    config.sops.secrets.laptop-luuk-password.path;
  users.users.luuk2.initialPassword = "test123";
  users.users.luuk2.isNormalUser = true;
  users.users.luuk2.extraGroups = lib.mkAfter [ "seat" "wheel" ];

}
