{ config, lib, ... }:
lib.mkIf config.cfg.laptop.enable {
  services.tlp = {
    enable = true;
    settings = {
      "STOP_CHARGE_THRESH_${config.cfg.laptop.battery}" = 80;
      "START_CHARGE_THRESH_${config.cfg.laptop.battery}" = 75;

      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;

      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "balanced";

      USB_AUTOSUSPEND = 1;
    };
  };
}
