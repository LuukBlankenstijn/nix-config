{ config, lib, ... }:
lib.mkMerge [
  (lib.mkIf config.cfg.desktop.enable {
    security.polkit.enable = true;
    programs.dconf.enable = true;

    security.pam.services.login.enableGnomeKeyring = true;

    services = {
      gnome.gnome-keyring.enable = true;
      fwupd.enable = true;
      fstrim.enable = true;
      gvfs.enable = true;
      tumbler.enable = true;
      upower.enable = true;
      hardware.bolt.enable = true;
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
    systemd.sleep.settings.Sleep = {
      AllowHibernation = "no";
      AllowSuspendThenHibernate = "no";
      AllowHybridSleep = "no";
    };

    services.upower = {
      enable = true;
      criticalPowerAction = "Hibernate";
      percentageAction = 3;
    };
    services.logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchDocked = "suspend";
      HandleLidSwitchExternalPower = "suspend";

      HandlePowerKey = "lock";
      HandlePowerKeyLongPress = "poweroff";
    };
  })
]
