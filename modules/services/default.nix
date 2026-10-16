{ ... }:
{
  imports = [
    ./headscale.nix
    ./traefik.nix
    ./k3s.nix
    ./comin.nix
    ./home-assistant.nix
  ];
}
