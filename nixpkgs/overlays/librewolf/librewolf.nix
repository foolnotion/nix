{ appimageTools, makeDesktopItem, fetchurl, gsettings-desktop-schemas, gtk3 }:

let
  pname = "librewolf-bin";
  version = "87.0-1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://gitlab.com/librewolf-community/browser/linux/uploads/4c8bb4ed933bf5fbae3d6645d1152340/LibreWolf-${version}.x86_64.AppImage";
    sha256 = "d2a70d98b7ebd68eb64ea49ae5dcc5aaaa327bc1ac290973d9c5ad772aece7a2";
  };

  appimageContents = appimageTools.extractType2 { inherit name src; };
  in appimageTools.wrapType2 {
    inherit name src;

    # Fix for file dialog crash
    profile = ''
      export LC_ALL=C.UTF-8
      export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
    '';

    extraInstallCommands = ''
      mv $out/bin/${name} $out/bin/${pname}
  '';
}

