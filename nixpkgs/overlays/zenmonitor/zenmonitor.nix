{ lib, stdenv, fetchFromGitHub, pkg-config, gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "zenmonitor";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "ocerman";
    repo = "zenmonitor";
    rev = "v${version}";
    sha256 = "0smv94vi36hziw42gasivyw25h5n1sgwwk1cv78id5g85w0kw246";
  };

  buildInputs = [ gtk3 ];
  nativeBuildInputs = [ pkg-config wrapGAppsHook ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  patches = [
    ./ZEN3_support.patch
    ./ZEN3_fix_tdie_tctl_order.patch
  ];

  meta = with lib; {
    description = "Monitoring software for AMD Zen-based CPUs";
    homepage = "https://github.com/ocerman/zenmonitor";
    license = licenses.mit;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ alexbakker ];
  };
}

