{
  config,
  lib,
  ...
}:
# the fingerprint service and all pam options are automatically enabled by factor if there is a scanner
lib.mkIf config.services.fprintd.enable {
  environment.persistence."/persist" = lib.mkIf config.cfg.impermanence.enable {
    directories = [
      "/var/lib/fprint"
    ];
  };
}
