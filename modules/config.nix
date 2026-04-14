{ lib, config, ... }:
let
  inherit (lib)
    mkOption
    mkEnableOption
    mkDefault
    mkIf
    types
    ;
in
{
  options.cfg = {

    # ── infrastructure ──────────────────────────────────────────────────────────
    impermanence.enable = mkEnableOption "ZFS impermanence (ephemeral root, /persist)";

    # ── system features ─────────────────────────────────────────────────────────
    desktop = {
      enable = mkEnableOption "desktop environment (Hyprland, portals, etc.)";
      displayManager.enable = mkEnableOption "display manager (ReGreet)";
      audio.enable = mkEnableOption "audio stack (PipeWire, ALSA, JACK, PulseAudio compat)";
      hardware.enable = mkEnableOption "desktop hardware support (firmware, GPU drivers)";
    };

    server.enable = mkEnableOption "server-specific features (OpenSSH, wheel passwordless sudo)";

    bluetooth.enable = mkEnableOption "Bluetooth hardware + blueman";

    networking = {
      enable = mkEnableOption "NetworkManager";
      wifi.enable = mkEnableOption "Wi-Fi support (iwd)";
      tailscale = {
        enable = mkEnableOption "Tailscale mesh VPN";
        loginServer = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Optional login server for Tailscale (e.g. Headscale URL)";
        };
      };
      netbird.enable = mkEnableOption "Netbird mesh VPN";
      nftables.enable = mkEnableOption "nftables backend (instead of iptables)";
    };

    laptop.enable = mkEnableOption "laptop features (TLP power management, lid-switch handling)";

    virtualisation = {
      docker.enable = mkEnableOption "Docker container runtime";
      podman = {
        enable = mkEnableOption "Podman container runtime";
        dockerAlias = mkEnableOption "alias podman to docker";
      };
      libvirtd.enable = mkEnableOption "libvirtd (KVM/QEMU hypervisor)";
      virtManager.enable = mkEnableOption "virt-manager GUI (implies libvirtd)";
    };

    services = {
      headscale.enable = mkEnableOption "Headscale – self-hosted Tailscale control server";
      traefik.enable = mkEnableOption "Traefik – reverse proxy and edge router";
      k3s = {
        enable = mkEnableOption "K3s – lightweight Kubernetes distribution";
        clusterInit = mkEnableOption "initialize a new cluster with embedded etcd";
      };
    };

    # ── identity ────────────────────────────────────────────────────────────────
    user = mkOption {
      type = types.str;
      description = "Primary username for this machine";
    };

    # ── per-user config ─────────────────────────────────────────────────────────
    users = mkOption {
      default = { };
      description = "Per-user configuration, keyed by username";
      type = types.attrsOf (
        types.submodule (_: {
          options = {

            # ── desktop ────────────────────────────────────────────────────────
            desktop = {
              enable = mkEnableOption "desktop environment (GUI apps, XDG, theming)";

              hyprland = {
                enable = mkEnableOption "Hyprland window manager";
                idle.enable = mkEnableOption "hypridle (auto screen dim / lock / suspend)";
                lock.enable = mkEnableOption "hyprlock (lock screen)";
                paper.enable = mkEnableOption "hyprpaper (wallpaper daemon)";
                shell.enable = mkEnableOption "hyprshell (window overview / switcher)";
                picker.enable = mkEnableOption "hyprpicker (screen colour picker)";
                mon.enable = mkEnableOption "hyprmon (monitor profile manager)";
                pyprland.enable = mkEnableOption "pyprland scratchpad system";
              };

              cursor.enable = mkEnableOption "cursor theme (Adwaita)";
              nautilus.enable = mkEnableOption "Nautilus file manager";
              styling.enable = mkEnableOption "GTK/Qt dark theming (Adwaita)";
              waybar.enable = mkEnableOption "Waybar status bar";
              keyring.enable = mkEnableOption "Seahorse keyring GUI";

              terminal.enable = mkEnableOption "Ghostty terminal emulator";
              browser.enable = mkEnableOption "Zen browser";
              email.enable = mkEnableOption "email clients (Thunderbird, ProtonMail Bridge)";
              tailscale.enable = mkEnableOption "Tailscale system-tray applet";
              bluetooth.enable = mkEnableOption "Bluetooth GUI (Overskride, waybar widget)";

              winapps.enable = mkEnableOption "WinApps – Windows applications via Docker/RDP";
            };

            # ── general tools ──────────────────────────────────────────────────
            git.enable = mkEnableOption "git configuration";
            neovim.enable = mkEnableOption "Neovim editor";
            ranger.enable = mkEnableOption "Ranger file manager";
            rbw.enable = mkEnableOption "rbw Bitwarden CLI";
            shell.enable = mkEnableOption "zsh shell configuration";
            clipboard = {
              enable = mkEnableOption "clipboard tools (wl-clipboard, xclip, osc52)";
              history.enable = mkEnableOption "clipboard history (cliphist)";
            };

            # ── extra packages ─────────────────────────────────────────────────
            extraPackages = mkOption {
              type = types.listOf types.package;
              default = [ ];
              description = "Extra packages to install for this user";
            };

            gewis.enable = mkEnableOption "GEWIS organisation configuration";
          };
        })
      );
    };

    # ── convenience ─────────────────────────────────────────────────────────────
    userConfig = mkOption {
      readOnly = true;
      description = "Shorthand for config.cfg.users.<config.cfg.user>";
      default = config.cfg.users.${config.cfg.user} or { };
    };
  };

  # ── dependency wiring ───────────────────────────────────────────────────────
  config = {
    # virt-manager requires libvirtd
    cfg.virtualisation.libvirtd.enable = mkIf config.cfg.virtualisation.virtManager.enable (
      mkDefault true
    );

    # winapps (any user) requires docker or podman
    cfg.virtualisation.docker.enable = mkIf (
      !config.cfg.virtualisation.podman.enable
      && (builtins.any (u: u.desktop.winapps.enable) (builtins.attrValues config.cfg.users))
    ) (mkDefault true);
  };
}
