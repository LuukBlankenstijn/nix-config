{ ... }:
{
  imports = [
    ./tailscale.nix
    ./ssh.nix
    ./netbird.nix
    ./nftables.nix
    ../desktop/networking.nix
  ];
}
