{ config, lib, ... }:
lib.mkMerge [
  (lib.mkIf config.cfg.desktop.enable {
    security.polkit.enable = true;
    services = {
      gnome.gnome-keyring.enable = true;
      fwupd.enable = true;
      fstrim.enable = true;
      gvfs.enable = true;
      tumbler.enable = true;
      upower.enable = true;
    };
  })

  (lib.mkIf config.cfg.desktop.audio.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  })

  (lib.mkIf config.cfg.laptop.enable {
    services.logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchDocked = "ignore";
    };
  })
]
