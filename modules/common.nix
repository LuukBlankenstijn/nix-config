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
  ];

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings.trusted-users = [
      "root"
      "@wheel"
    ];

    settings.extra-substituters = [ "https://oh-my-pi.cachix.org" ];
    settings.extra-trusted-public-keys = [
      "oh-my-pi.cachix.org-1:FRLFzcZnCIB2GfSpDkgHsl8uGa1zDrx1F+bBlVIy7Wo="
    ];
  };

  users.users.${config.cfg.user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]
      ++ lib.optional config.cfg.networking.enable "networkmanager"
      ++ lib.optional config.cfg.networking.netbird.enable "netbird";
  };
  users.defaultUserShell = pkgs.zsh;
}
