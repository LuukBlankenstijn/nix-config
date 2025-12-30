{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.openssh ];

  programs.ssh = { startAgent = true; };
}
