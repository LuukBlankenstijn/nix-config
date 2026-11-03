{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  curl,
  jq,
  coreutils,
  gnused,
  util-linux,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "claudebar";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "mryll";
    repo = "claudebar";
    rev = "v${finalAttrs.version}";
    hash = "sha256-K9072poFrxod6vVXjEoG+420cvD+6IzkWeRiqS1qw+c=";
  };

  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;

  postPatch = ''
    substituteInPlace claudebar \
      --replace-fail "'try (.extra_usage != null) catch false' <<< \"\$usage\" 2>/dev/null)" \
        "'try (((.extra_usage.monthly_limit | numbers) // 0) > 0 or ((.extra_usage.used_credits | numbers) // 0) > 0) catch false' <<< \"\$usage\" 2>/dev/null)"
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 claudebar $out/bin/claudebar
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/claudebar \
      --prefix PATH : ${
        lib.makeBinPath [
          curl
          jq
          coreutils
          gnused
          util-linux
        ]
      }
  '';

  meta = {
    description = "Claude AI plan usage widget (session/weekly limits)";
    homepage = "https://github.com/mryll/claudebar";
    license = lib.licenses.mit;
    mainProgram = "claudebar";
    platforms = lib.platforms.linux;
  };
})
