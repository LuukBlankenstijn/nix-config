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
  fhs = pkgs.buildFHSEnv {
    name = "omp";
    targetPkgs =
      p:
      [
        bun'
      ]
      ++ (with p; [
        nodejs_22
        git
        stdenv.cc.cc.lib
        zlib
      ])
      ++ (cfg.extraLibraries p);
    runScript = pkgs.writeShellScript "omp-run" ''
      export BUN_INSTALL="$HOME/.bun"
      export PATH="$BUN_INSTALL/bin:$PATH"
      # Use absolute path: the user profile stays on PATH inside the FHS sandbox,
      # so `command -v omp` would resolve to this wrapper and recurse.
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
  };
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
        Extra libraries to expose inside the FHS sandbox, in case omp's native
        addon dlopens something not covered by the defaults. Run
        `ldd $(find ~/.bun -name '*.node')` after install to find missing ones.
      '';
    };
  };

  config = lib.mkIf osConfig.cfg.userConfig.omp.enable {
    home.packages = [ fhs ];
  };
}
