{ config, lib, ... }:
lib.mkIf config.cfg.laptop.enable {
  services.tlp = {
    enable = true;
    settings = {
      STOP_CHARGE_THRESH_BAT0 = 80;
      START_CHARGE_THRESH_BAT0 = 75;

      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "power";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_BOOST_ON_AC = 0;
      CPU_BOOST_ON_BAT = 0;

      PLATFORM_PROFILE_ON_AC = "low-power";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      USB_AUTOSUSPEND = 1;
    };
  };
}
