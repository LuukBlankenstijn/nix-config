{ pkgs, ... }:
{
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    age
    btop
    git
    vim
    bind
    jq
    openssh
    ripgrep
    wget
    unzip
    zip
    tree
    file
    tailscale
  ];

  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--operator=luuk" ];
  };

  environment.persistence."/persist".directories = [ "/var/lib/tailscale" ];
}
