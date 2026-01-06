let
  luuk =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHnm7ME9L/KuEGbSbzPJ4uVgsNl579UCCtXAIlWNYq7x";
  laptop-old =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMnlLgHzylbtFJz0+oomYcJASx204onj+TUo3ZIp0A9T";
in { "laptop-luuk-password.age".publicKeys = [ luuk laptop-old ]; }
