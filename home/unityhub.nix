# {pkgs ? import <nixpkgs> {} }:
# pkgs.appimageTools.wrapType2 { # or wrapType1
#   name = "unityhub";
#   src = pkgs.fetchurl {
#     url = "https://gitlab.com/api/v4/projects/35953384/packages/generic/Unity_Hub/3.3.0/Unity_Hub-3.3.0.glibc2.34-x86_64.AppImage";
#     sha256 = "1smpb1day2sip0hv7s2sivkn9jnprm8rzjdi4hsrb6pld54piz4m";
#   };
#   extraPkgs = pkgs: with pkgs; [ ];
# }

{ # lib, fetchurl, appimageTools
  # pkgs ? import <nixpkgs> {}
  lib, fetchurl, appimageTools, pkgs
}:
# let
#   lib = pkgs.lib;
#   fetchurl = pkgs.fetchurl;
#   appimageTools = pkgs.appimageTools;
#   in
appimageTools.wrapType2 rec {
  pname = "unityhub";
  version = "3.3";

  src = fetchurl {
    # url = "https://gitlab.com/api/v4/projects/35953384/packages/generic/Unity_Hub/3.3.0/Unity_Hub-3.3.0.glibc2.34-x86_64.AppImage";
    # sha256 = "1smpb1day2sip0hv7s2sivkn9jnprm8rzjdi4hsrb6pld54piz4m";
    url = "https://public-cdn.cloud.unity3d.com/hub/prod/UnityHub.AppImage";
    sha256= "0yp3rhv2jbi1bg7wws4nhr46slp2wnya7ly9j894ccllhnzijshn";
  };

  extraPkgs = (pkgs: with pkgs; with xorg; [ gtk2 gdk-pixbuf glib libGL libGLU nss nspr
    alsa-lib cups libcap fontconfig freetype pango
    cairo dbus dbus-glib libdbusmenu libdbusmenu-gtk2 expat zlib libpng12 udev tbb
    libpqxx gtk3 libsecret lsb-release openssl nodejs ncurses5

    libX11 libXcursor libXdamage libXfixes libXrender libXi
    libXcomposite libXext libXrandr libXtst libSM libICE libxcb

    libselinux pciutils libpulseaudio libxml2 icu clang cacert
  ]);

  extraInstallCommands =
    let appimageContents = appimageTools.extractType2 { inherit pname version src; }; in
    ''
      install -Dm444 ${appimageContents}/unityhub.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/unityhub.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
      install -m 444 -D ${appimageContents}/unityhub.png \
        $out/share/icons/hicolor/64x64/apps/unityhub.png
    '';

  meta = with lib; {
    homepage = "https://unity3d.com/";
    description = "Game development tool";
    longDescription = ''
      Popular development platform for creating 2D and 3D multiplatform games
      and interactive experiences.
    '';
    # license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ tesq0 ];
  };
}
