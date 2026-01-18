{ pkgs, ... }:
{
  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu.vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };
  programs.virt-manager.enable = true;

  environment.persistence."/persist".directories = [
    "/var/lib/docker"
    "/var/lib/libvirt"
  ];
}
