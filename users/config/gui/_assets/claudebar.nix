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
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "mryll";
    repo = "claudebar";
    rev = "v${finalAttrs.version}";
    sha256 = "137fabzxlzw7vvmkqmwp4ln9wbhmpxn4w3aiabdl2imhfsvf9vxm";
  };

  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;

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
