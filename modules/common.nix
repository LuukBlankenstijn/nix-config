{ config, lib, pkgs, ... }:
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
    extraSetFlags = [ "--operator=${config.cfg.user}" ];
  };

  services.netbird = {
    ui.enable = true;
    clients.default = {
      name = "netbird";
      port = 51820;
    };
  };
  users.users.${config.cfg.user}.extraGroups = [ "netbird" ];

  environment.persistence."/persist".directories = lib.mkIf config.cfg.impermanence.enable [
    "/var/lib/tailscale"
    "/var/lib/netbird"
  ];
}
