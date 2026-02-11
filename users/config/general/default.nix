{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./keyring.nix
    ./nvim.nix
    ./ranger.nix
    ./shell.nix
    ./rbw.nix
  ];

  home.packages = with pkgs; [
    claude-code
    prismlauncher
    slack
  ];
}
