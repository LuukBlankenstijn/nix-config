{ appimageTools, fetchurl }:
let
  pname = "elegoo-slicer";
  version = "1.5.3.5";

  src = fetchurl {
    url = "https://github.com/elegooofficial/ElegooSlicer/releases/download/v${version}/ElegooSlicer_Linux_V${version}.AppImage";
    hash = "sha256:7b3b3f08e0d0d51bb472c85865d1be9b0c28385423daba1cb0c3b225d0101afc";
  };

  contents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs =
    pkgs: with pkgs; [
      webkitgtk_4_1
      libsoup_3
      libsecret
      libGLU
      glib-networking
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
    ];

  extraInstallCommands = ''
    install -Dm444 ${contents}/com.orcaslicer.ElegooSlicer.desktop $out/share/applications/elegoo-slicer.desktop
    substituteInPlace $out/share/applications/elegoo-slicer.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    install -Dm444 ${contents}/usr/share/icons/hicolor/192x192/apps/ElegooSlicer.png \
      $out/share/icons/hicolor/192x192/apps/ElegooSlicer.png
  '';

  meta.mainProgram = pname;
}
