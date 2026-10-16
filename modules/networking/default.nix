{ ... }:
{
  imports = [
    ./ssh.nix
    ./netbird.nix
    ./nftables.nix
    ./wireguard.nix
    ../desktop/networking.nix
  ];
}
