{ ... }: {
  imports = [ ../config/gui ../config/general ../config/ssh-client.nix ];

  home.username = "luuk";
  home.homeDirectory = "/home/luuk";

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
