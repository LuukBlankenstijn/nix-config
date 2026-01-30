{
  pkgs,
  ...
}:

let
  # Declarative CoreDNS config
  corefile = pkgs.writeText "Corefile" ''
    # Handle .test domains
    test:53 {
        rewrite name regex .*\.test traefik answer auto

        forward . 127.0.0.11

        log
        errors
    }

    .:53 {
        forward . 1.1.1.1 8.8.8.8
        log
        errors
    }
  '';

  # Declarative Docker Compose File
  devComposeFile = pkgs.writeText "dev-compose.yaml" ''
    services:
      dns:
        image: coredns/coredns
        command: -conf /Corefile
        volumes:
          - ${corefile}:/Corefile
        networks:
          dev_net:
            ipv4_address: 172.28.0.80
          qlico-core:
      socks:
        image: alpine:latest
        entrypoint: /bin/sh -c "apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing microsocks && microsocks -i 0.0.0.0"
        ports:
          - "1080:1080"
        networks: 
          - dev_net
          - qlico-core
        dns: 
          - 172.28.0.80
    networks:
      dev_net:
        ipam:
          config:
            - subnet: 172.28.0.0/16
      qlico-core:
        name: qlico-core
        external: true
  '';

  dockerCmd = "${pkgs.docker}/bin/docker";

in
{
  home.packages = with pkgs; [
    mkcert
    nss.tools
    rsync
    docker
  ];

  home.file."work/code/.envrc".text = ''
    # Nix managed, ignore
    layout work
  '';

  programs.git = {
    enable = true;
    extraConfig = {
      "includeIf \"gitdir:/home/luuk/work/\"".path = "${pkgs.writeText "work-git-config" ''
        [core]
          excludesFile = ${pkgs.writeText "work-ignore" ''
            .envrc
            .direnv/
          ''}
      ''}";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      whitelist.prefix = [ "/home/luuk/work" ];
    };
    stdlib = ''
            layout_work() {
              use flake "github:loophp/nix-shell#env-php84" --impure

              # Start Docker
              ${dockerCmd} compose -f ${devComposeFile} up -d || true
              
              # --- CONFIGURATION ---
              export PROXY_PORT=1080
              # We use your existing compose file var but point to the Nix store version
              export COMPOSE_FILE="${devComposeFile}"

              # --- PATHS ---
              local PROJECT_HASH=$(echo -n "$PWD" | md5sum | cut -d' ' -f1)
              # We move LAUNCHER to a cache dir to avoid .direnv folder in the repo
              local CACHE_DIR="$HOME/.cache/nix-dev-shells/$PROJECT_HASH"
              local LAUNCHER="$CACHE_DIR/zen-dev"
              local DESKTOP_SOURCE="$CACHE_DIR/zen-dev-$PROJECT_HASH.desktop"
              
              mkdir -p "$CACHE_DIR"

              if ! ${dockerCmd} compose -f "$COMPOSE_FILE" ps --services --filter "status=running" | grep -q "socks"; then
                  ${dockerCmd} compose -f "$COMPOSE_FILE" up -d
              fi
              alias down="${dockerCmd} compose -f '$COMPOSE_FILE' down"

              # --- GENERATE LAUNCHER (Your exact logic) ---
              cat <<EOF > "$LAUNCHER"
      #!/usr/bin/env bash
      PROXY_PORT="$PROXY_PORT"
      SESSION_DIR="/tmp/zen-snap-$PROJECT_HASH"
      PROFILE_DIR="\$SESSION_DIR/profile"

      if [ -d "\$SESSION_DIR" ]; then
          chmod -R u+w "\$SESSION_DIR" 2>/dev/null
          rm -rf "\$SESSION_DIR"
      fi
      mkdir -p "\$SESSION_DIR"

      REAL_PROFILE=""
      if [ -d "\$HOME/.zen/default" ]; then
          REAL_PROFILE="\$HOME/.zen/default"
      elif [ -d "\$HOME/.zen" ]; then
          REAL_PROFILE=\$(${pkgs.findutils}/bin/find "\$HOME/.zen" -maxdepth 1 -type d -name "*.default-release" -o -name "*.default" | head -n 1)
      fi

      if [ -n "\$REAL_PROFILE" ]; then
          ${pkgs.rsync}/bin/rsync -rLptgoD --chmod=u=rwX --exclude "cache2" --exclude "lock" "\$REAL_PROFILE/" "\$PROFILE_DIR/"
      else
          mkdir -p "\$PROFILE_DIR"
      fi

      chmod -R u+w "\$PROFILE_DIR"

      MKCERT_ROOT="\$(${pkgs.mkcert}/bin/mkcert -CAROOT)/rootCA.pem"
      if [ -f "\$MKCERT_ROOT" ]; then
          if ! ${pkgs.nss.tools}/bin/certutil -L -d "sql:\$PROFILE_DIR" > /dev/null 2>&1; then
              rm -f "\$PROFILE_DIR/cert9.db" "\$PROFILE_DIR/key4.db"
              ${pkgs.nss.tools}/bin/certutil -N -d "sql:\$PROFILE_DIR" --empty-password
          fi
          ${pkgs.nss.tools}/bin/certutil -A -d "sql:\$PROFILE_DIR" -n "mkcert-local-dev" -t "C,," -i "\$MKCERT_ROOT" > /dev/null 2>&1
      fi

      USER_JS="\$PROFILE_DIR/user.js"
      touch "\$USER_JS"
      chmod u+w "\$USER_JS"

      {
          echo '// DOCKER PROXY SETTINGS'
          echo 'user_pref("network.proxy.type", 1);'
          echo 'user_pref("network.proxy.socks", "127.0.0.1");'
          echo "user_pref(\"network.proxy.socks_port\", \$PROXY_PORT);"
          echo 'user_pref("network.proxy.socks_version", 5);'
          echo 'user_pref("network.proxy.socks_remote_dns", true);'
      } >> "\$PROFILE_DIR/user.js"

      zen --profile "\$PROFILE_DIR" --new-instance --no-remote https://google.com
      EOF

              chmod +x "$LAUNCHER"
              PATH_add "$CACHE_DIR"

              # --- GENERATE DESKTOP ENTRY ---
              cat <<EOF > "$DESKTOP_SOURCE"
      [Desktop Entry]
      Type=Application
      Name=Zen Dev
      Comment=Isolated environment with Docker Proxy
      Exec="$LAUNCHER"
      Icon=zen-browser
      Terminal=false
      Categories=Network;WebBrowser;Development;
      StartupWMClass=zen
      EOF

              SYSTEM_DIR="$HOME/.local/share/applications"
              mkdir -p "$SYSTEM_DIR"
              ln -sf "$DESKTOP_SOURCE" "$SYSTEM_DIR/"
              ${pkgs.desktop-file-utils}/bin/update-desktop-database "$SYSTEM_DIR" > /dev/null 2>&1

              on_exit() {
                rm -f "$DESKTOP_FILE"
                ${pkgs.desktop-file-utils}/bin/update-desktop-database "$APPS_DIR" > /dev/null 2>&1
              }
            }
    '';
  };
}
