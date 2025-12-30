{ ... }: {
  imports = [ ./base.nix ];
  users.users.luuk = { initialPassword = "test123"; };
}
