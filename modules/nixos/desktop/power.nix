{ ... }:
{
  # TuneD - Tuning Profile Delivery Mechanism for Linux
  # A modern replacement for PPD(power-profiles-daemon)
  # services.tuned = {
  # enable = true;
  # settings.dynamic_tuning = true;
  # ppdSupport = true; # translation of power-profiles-daemon API calls to TuneD
  # ppdSettings.main.default = "balanced"; # balanced / performance / power-saver
  # };

  services.tlp = {
    enable = true;
    pd.enable = true;
    settings = {
      # On AC
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_BOOST_ON_AC = 1;
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;

      # On battery
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_BOOST_ON_BAT = 0;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 30;

      # Threshold
      # Not supported in my Laptop Fisher
      # START_CHARGE_THRESH_BAT0 = 40;
      # STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };
  # DBus service that provides power management support to applications
  # Required by `tuned-ppd` for handling power supply changes
  services.upower.enable = true;

  services.power-profiles-daemon.enable = false; # conflicts with tuned
  # services.tlp.enable = false; # conflicts with tuned
}
