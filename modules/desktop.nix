{ ... }: {
  imports = [ ./common.nix ./ssh-client.nix ];
  services.xserver.enable = false;

  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;
  security.pam.services.hyprlock = { };
  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = ./_assets/nature.jpg;
        fit = "Cover";
      };
      GTK = {
        application_prefer_dark_theme = true;
        cursor_blink = false;
      };
    };
  };

  networking.networkmanager.enable = true;
  hardware.enableAllFirmware = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  services.upower.enable = true;
  nixpkgs.config.allowUnfree = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.pipewire.enable = true;
  services.printing.enable = true;

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  programs.zsh.enable = true;
}
