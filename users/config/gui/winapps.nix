{
  osConfig,
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  username = "Luuk";
  password = "WindowsBahBah";
  yaml = pkgs.formats.yaml { };
  composeConfig = {
    name = "winapps";
    volumes.data = { };
    services.windows = {
      image = "ghcr.io/dockur/windows:latest";
      container_name = "WinApps";
      environment = {
        VERSION = "11";
        RAM_SIZE = "8G";
        CPU_CORES = "6";
        DISK_SIZE = "64G";
        USERNAME = username;
        PASSWORD = password;
        HOME = config.home.homeDirectory;
      };
      ports = [
        "8006:8006"
        "3389:3389/tcp"
        "3389:3389/udp"
      ];
      cap_add = [ "NET_ADMIN" ];
      stop_grace_period = "120s";
      restart = "on-failure";
      volumes = [
        "data:/storage"
        "${config.home.homeDirectory}:/shared"
        "./oem:/oem"
      ];
      devices = [
        "/dev/kvm"
        "/dev/net/tun"
      ];
    };
  };

  winappsConfig = ''
    RDP_USER="${username}"
    RDP_PASS="${password}"
    RDP_DOMAIN=""
    RDP_IP="127.0.0.1"
    VM_NAME="RDPWindows"
    WAFLAVOR="docker"
    RDP_SCALE="100"
    REMOVABLE_MEDIA="/run/media"
    RDP_FLAGS="/cert:tofu /sound /microphone +home-drive -sec:nla:off"
    RDP_FLAGS_NON_WINDOWS=""
    RDP_FLAGS_WINDOWS=""
    DEBUG="true"
    AUTOPAUSE="off"
    AUTOPAUSE_TIME="300"
    FREERDP_COMMAND=""
    PORT_TIMEOUT="5"
    RDP_TIMEOUT="30"
    APP_SCAN_TIMEOUT="60"
    BOOT_TIMEOUT="120"
    HIDEF="on"
  '';
in
lib.mkIf (osConfig.cfg.userConfig.desktop.enable && osConfig.cfg.userConfig.desktop.winapps.enable) {
  xdg.configFile."winapps/compose.yaml".source = yaml.generate "compose.yaml" composeConfig;
  xdg.configFile."winapps/winapps.conf".text = winappsConfig;
  home.packages = [
    inputs.winapps.packages.${pkgs.stdenv.hostPlatform.system}.winapps
    inputs.winapps.packages.${pkgs.stdenv.hostPlatform.system}.winapps-launcher
  ];
}
