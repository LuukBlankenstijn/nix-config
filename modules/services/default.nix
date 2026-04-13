{ ... }:
{
  imports = [
    ./headscale.nix
    ./traefik.nix
    ./k3s.nix
  ];
}
