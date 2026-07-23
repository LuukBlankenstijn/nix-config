{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  cfg = config.programs.omp;
  # bun 1.3.14 required; nixpkgs ships 1.3.13.
  bun' = pkgs.bun.overrideAttrs (old: {
    version = "1.3.14";
    src = pkgs.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v1.3.14/bun-linux-x64.zip";
      hash = "sha256-lR7iruhV8IWVruxiJSJqKY0/6oOj3NZGXAnLzN9+hI8=";
    };
  });
  runtimeDeps = [
    bun'
    pkgs.nodejs_22
    pkgs.git
  ];
  runtimeLibs = (with pkgs; [
    stdenv.cc.cc.lib
    zlib
  ]) ++ (cfg.extraLibraries pkgs);
  omp = pkgs.writeShellScriptBin "omp" ''
    export BUN_INSTALL="$HOME/.bun"
    export PATH="${lib.makeBinPath runtimeDeps}:$BUN_INSTALL/bin:$PATH"
    export LD_LIBRARY_PATH="${lib.makeLibraryPath runtimeLibs}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    # omp's browser tool uses Puppeteer, whose bundled Chromium is dynamically
    # linked against FHS paths and can't run on NixOS. Point it at a Nix-built
    # Chromium instead (officially supported override, browser tool only).
    export PUPPETEER_EXECUTABLE_PATH="${lib.getExe pkgs.chromium}"
    bin="$BUN_INSTALL/bin/omp"
    pkg="@oh-my-pi/pi-coding-agent${lib.optionalString (cfg.version != null) "@${cfg.version}"}"
    if [ ! -x "$bin" ]; then
      echo "omp: installing $pkg (first run)..." >&2
      bun install -g "$pkg"
    ${lib.optionalString (cfg.version != null) ''
      elif [ "$("$bin" --version 2>/dev/null | tr -d '[:space:]')" != "${cfg.version}" ]; then
        echo "omp: updating to $pkg..." >&2
        bun install -g "$pkg"
    ''}
    fi
    exec "$bin" "$@"
  '';
in
{
  options.programs.omp = {
    version = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "16.0.10";
      description = ''
        Pin a specific version of @oh-my-pi/pi-coding-agent. When set, the
        wrapper reinstalls if the installed version drifts. null tracks latest
        (installed once, never auto-updated).
      '';
    };
    extraLibraries = lib.mkOption {
      type = lib.types.functionTo (lib.types.listOf lib.types.package);
      default = _: [ ];
      defaultText = lib.literalExpression "pkgs: [ ]";
      example = lib.literalExpression "pkgs: [ pkgs.openssl ]";
      description = ''
        Extra libraries exposed via LD_LIBRARY_PATH for omp's native addons.
        Run `ldd $(find ~/.bun -name '*.node')` after install to find missing ones.
      '';
    };
  };

  config = lib.mkIf osConfig.cfg.userConfig.omp.enable {
    home.packages = [ omp ];
  };
}
