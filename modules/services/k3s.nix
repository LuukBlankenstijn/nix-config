{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.cfg.services.k3s;
in
{
  config = mkMerge [
    (mkIf cfg.enable {
      services.k3s = {
        enable = true;
        role = "server";
        inherit (cfg) clusterInit;

        extraFlags = [
          "--write-kubeconfig-mode=0644"
          "--etcd-expose-metrics=true"
          "--disable=traefik"
          "--disable-network-policy"
        ];
      };

      # stuff needed to make Longhorn
      services.openiscsi = {
        enable = true;
        name = "${config.networking.hostName}-initiatorhost";
      };
      systemd.services.iscsid.serviceConfig = {
        PrivateMounts = "yes";
        BindPaths = "/run/current-system/sw/bin:/bin";
      };
      systemd.tmpfiles.rules = [
        "L /usr/bin/mount - - - - /run/current-system/sw/bin/mount"
      ];

      networking.firewall = {
        allowedTCPPorts = [
          6443 # k3s API
          10250 # kubelet
          2379 # etcd client
          2380 # etcd peer
          10257 # kube-controller-manager
          10259 # kube-scheduler
        ];
        allowedUDPPorts = [
          8472 # flannel VXLAN
          51820 # flannel Wireguard
        ];
      };
      boot = {

        kernelModules = [ "br_netfilter" ];
        kernel.sysctl = {
          "net.ipv4.ip_forward" = 1;
          "net.ipv6.conf.all.forwarding" = 1;
          "net.bridge.bridge-nf-call-iptables" = 1;
          "net.bridge.bridge-nf-call-ip6tables" = 1;
        };
      };
      environment = {
        systemPackages = with pkgs; [
          k9s
          kubeseal
          fluxcd
        ];

        sessionVariables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";

        persistence."/persist" = lib.mkIf config.cfg.impermanence.enable {
          directories = [
            "/var/lib/rancher/k3s"
            "/etc/rancher/k3s"
          ];
        };
      };
    })

    (mkIf (cfg.enable && cfg.gpu.enable) {
      hardware.graphics.enable = true;
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        modesetting.enable = true;
        open = false;
        nvidiaSettings = false;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        powerManagement.enable = true;
      };

      hardware.nvidia-container-toolkit = {
        enable = true;
        device-name-strategy = "uuid";
      };

      services.k3s.containerdConfigTemplate = ''
        {{ template "base" . }}

        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia]
          privileged_without_host_devices = false
          runtime_engine = ""
          runtime_root = ""
          runtime_type = "io.containerd.runc.v2"
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia.options]
          BinaryName = "${pkgs.nvidia-container-toolkit.tools}/bin/nvidia-container-runtime.cdi"
      '';

      services.k3s.extraFlags = [
        "--node-label=gpu=true"
        "--node-label=workload=ai"
      ];
    })
  ];
}
