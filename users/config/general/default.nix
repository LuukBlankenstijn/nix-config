{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./nvim.nix
    ./ranger.nix
    ./shell.nix
  ];

  home.packages = with pkgs; [
    codex
    prismlauncher
  ];
}
