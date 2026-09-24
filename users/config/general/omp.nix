{
  lib,
  pkgs,
  osConfig,
  inputs,
  ...
}:
let
  ompCfg = osConfig.cfg.userConfig.omp;
  omp = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "omp";
    version = (lib.importJSON "${inputs.omp}/packages/coding-agent/package.json").version;

    src = pkgs.fetchurl {
      url = "https://github.com/can1357/oh-my-pi/releases/download/v${finalAttrs.version}/omp-linux-x64";
      hash = "sha256-0v2qKa/+luWW65x41C9Ujx8pHfKGCGMbzAB1CoS5S8M=";
    };

    dontUnpack = true;
    dontStrip = true;

    nativeBuildInputs = [
      pkgs.autoPatchelfHook
      pkgs.bun
      pkgs.makeWrapper
      pkgs.patchelf
    ];
    buildInputs = [ pkgs.stdenv.cc.cc.lib ] ++ lib.optional (pkgs.stdenv.cc.cc ? libgcc) pkgs.stdenv.cc.cc.libgcc;

    installPhase = ''
      runHook preInstall
      install -Dm755 "$src" "$out/bin/omp"
      runHook postInstall
    '';

    postFixup = ''
      patchelf --add-needed libstdc++.so.6 "$out/bin/omp"
      wrapProgram "$out/bin/omp" \
        --set-default OMP_NATIVE_LIBRARY_PATH "${lib.makeLibraryPath finalAttrs.buildInputs}" \
        --set-default PUPPETEER_EXECUTABLE_PATH ${lib.getExe pkgs.chromium}
    '';

    preInstallCheck = ''
      bun ${inputs.omp}/scripts/fix-dt-verdef.ts "$out/bin/.omp-wrapped"
    '';

    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck
      smokeOutput="$(HOME="$TMPDIR" "$out/bin/omp" --smoke-test)"
      grep -q "smoke-test: ok" <<<"$smokeOutput"
      env -u LD_LIBRARY_PATH BUN_BE_BUN=1 "$out/bin/omp" -e \
        'const {dlopen}=require("bun:ffi");const dirs=(process.env.OMP_NATIVE_LIBRARY_PATH||"").split(":").filter(Boolean);const need={"libstdc++.so.6":{__cxa_demangle:{args:["ptr","ptr","ptr","ptr"],returns:"ptr"}},"libgcc_s.so.1":{_Unwind_Backtrace:{args:["ptr","ptr"],returns:"i32"}}};for(const lib of Object.keys(need)){let ok=false;for(const d of dirs){try{dlopen(d+"/"+lib,need[lib]);ok=true;break}catch(e){}}if(!ok){console.error("unresolved: "+lib);process.exit(1)}}'
      patchelf --print-needed "$out/bin/.omp-wrapped" | grep -q '^libstdc++\.so\.6$'
      runHook postInstallCheck
    '';

    meta = {
      mainProgram = "omp";
      platforms = [ "x86_64-linux" ];
    };
  });
  hasDefaultRole = ompCfg.modelRoles ? default;
in
{
  imports = [ inputs.omp.homeManagerModules.default ];

  config = lib.mkIf ompCfg.enable {
    assertions = [
      {
        assertion = hasDefaultRole;
        message = "cfg.users.${osConfig.cfg.user}.omp.modelRoles needs a default role";
      }
    ];

    programs.omp = {
      enable = true;
      package = omp;

      settings = lib.recursiveUpdate {
        setupVersion = 2;
        modelRoles = ompCfg.modelRoles;
        defaultThinkingLevel = "auto";
        hideThinkingBlock = true;
        steeringMode = "all";
        interruptMode = "immediate";
        memory.backend = "mnemopi";
        edit.mode = "hashline";
        checkpoint.enabled = true;
        github.enabled = true;
        secrets.enabled = true;
        advisor = {
          enabled = true;
          syncBacklog = "off";
        };
        bash.autoBackground.enabled = true;
        task.agentAdvisor.task = "on";
        composer.shape = "borderless";
        dev.autoqaConsent = "granted";
      } ompCfg.extraSettings;
    };
  };
}
