{ ... }: {
  imports = [ ./base.nix ];

  users.users.luuk.extraGroups = [ "docker" "libvirtd" ];

  environment.persistence."/persist".users.luuk.directories = [ "." ];
}
