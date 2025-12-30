{ ... }: {
  imports = [ ./shell.nix ./git.nix ./nvim.nix ];

  programs.btop.enable = true;
}
