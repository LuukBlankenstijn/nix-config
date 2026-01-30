{ inputs, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../config/gui
    ../config/general
    ../config/ssh-client.nix
    ../config/gewis.nix
    ../config/work
  ];

  sops = {
    age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/home/luuk/.ssh/id_ed25519"
    ];
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  };

  home = {
    username = "luuk";
    homeDirectory = "/home/luuk";

    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
