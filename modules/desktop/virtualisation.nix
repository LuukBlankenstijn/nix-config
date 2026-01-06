{ ... }: {
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  environment.persistence."/persist".directories = [
    "/var/lib/docker"
    "/var/lib/libvirt"
  ];
}
