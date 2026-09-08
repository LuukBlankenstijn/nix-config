{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.cfg.desktop.touchscreen;
in
{
  config = mkIf (config.cfg.desktop.enable && cfg.enable && cfg.gestures.enable) {
    # The compositors get at the panel through logind, but lisgd reads evdev
    # itself, and evdev nodes are root:input by default. Tagging this one device
    # with uaccess gives the seat user an ACL on the touchscreen alone -- joining
    # the input group would have handed over the keyboard along with it.
    #
    # The name match is exact, so the "... UNKNOWN" nodes the digitizer registers
    # next to the real one keep their default permissions.
    #
    # This has to ship as a package rather than through services.udev.extraRules:
    # that lands in 99-local.rules, by which point systemd's 70-uaccess.rules has
    # already run the uaccess builtin. The tag still shows up in `udevadm info`,
    # but no ACL is ever applied and the device stays unreadable. 65- puts us after
    # 60-input-id.rules, which is what sets ID_INPUT_TOUCHSCREEN, and before 70.
    services.udev.packages = [
      (pkgs.writeTextFile {
        name = "touchscreen-uaccess-rules";
        destination = "/lib/udev/rules.d/65-touchscreen-uaccess.rules";
        text = ''
          SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_INPUT_TOUCHSCREEN}=="1", ATTRS{name}=="${cfg.device}", SYMLINK+="input/touchscreen", TAG+="uaccess"
        '';
      })
    ];
  };
}
