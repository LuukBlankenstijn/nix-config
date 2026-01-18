_: {
  security.rtkit.enable = true;
  security.polkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    gnome.gnome-keyring.enable = true;
    fwupd.enable = true;
    fstrim.enable = true;

    gvfs.enable = true;
    tumbler.enable = true;

    upower.enable = true;
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchDocked = "ignore";
    };
  };
}
