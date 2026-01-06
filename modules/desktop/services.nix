{ ... }: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  security.rtkit.enable = true;
  security.polkit.enable = true;

  services.gnome.gnome-keyring.enable = true;
  services.fwupd.enable = true;
  services.fstrim.enable = true;

  services.printing.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "ignore";
  };

  environment.persistence."/persist".directories = [
    "/etc/cups"
    "/var/spool/cups"
  ];
}
