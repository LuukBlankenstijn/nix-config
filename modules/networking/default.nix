{ ... }:
{
  imports = [
    ./tailscale.nix
    ./netbird.nix
    ./nftables.nix
    ../desktop/networking.nix
  ];
}
