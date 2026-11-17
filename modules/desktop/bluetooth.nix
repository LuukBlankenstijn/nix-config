{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.cfg.bluetooth.enable {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez.overrideAttrs (old: {
      patches =
        old.patches
        ++ lib.optional (lib.versionOlder old.version "5.88") (
          pkgs.fetchpatch2 {
            name = "a2dp-fix-loading-of-remote-sep-from-cache";
            url = "https://git.kernel.org/pub/scm/bluetooth/bluez.git/patch/?id=b7d71e5067856b0daf2f1f73b3fc95483236610e";
            hash = "sha256-0+YmgVASf+aExTZ/AAvJOEUXNx03ks6n9qRiHX3CCXE=";
          }
        );
    });
  };

  services.pipewire.wireplumber.extraConfig."51-bluez-no-autoswitch" = {
    "wireplumber.settings" = {
      "bluetooth.autoswitch-to-headset-profile" = false;
    };
  };

  environment.persistence."/persist" = lib.mkIf config.cfg.impermanence.enable {
    directories = [
      "/etc/bluetooth"
      "/var/lib/bluetooth"
    ];
  };
}
