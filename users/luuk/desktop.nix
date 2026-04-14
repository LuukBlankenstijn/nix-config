{
  inputs,
  osConfig,
  lib,
  ...
}:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../config/general
    ../config/ssh-client.nix
  ]
  ++ lib.optionals osConfig.cfg.userConfig.gewis.enable [ ../config/gewis.nix ]
  ++ lib.optionals osConfig.cfg.userConfig.desktop.enable [ ../config/gui ];

  sops = {
    age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/home/${osConfig.cfg.user}/.ssh/id_ed25519"
    ];
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  };

  home = {
    username = osConfig.cfg.user;
    homeDirectory = "/home/${osConfig.cfg.user}";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
