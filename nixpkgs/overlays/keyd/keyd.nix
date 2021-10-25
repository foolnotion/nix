{ lib, stdenv, fetchgit, udev, git }:

let
  pname = "keyd";
  version = "1.1.2";
in stdenv.mkDerivation rec {
  inherit version pname;

  src = fetchgit {
    url = "https://github.com/rvaiya/keyd.git";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-E9WHCJxTGwvkrwm4zXFye53nJU9GFtovIxRrpoL/VtM=";
  };

  buildInputs = [ git udev ];

  patches = [
    ./keyd.patch
  ];

  buildPhase = ''
    make LOCK_FILE=/home/bogdb/.keyd/keyd.lock LOG_FILE=/home/bogdb/.keyd/keyd.log CONFIG_DIR=/home/bogdb/.keyd
  '';

  installPhase = ''
    make install DESTDIR=$out PREFIX=
  '';

  meta = {
    description = "A key remapping daemon for linux.";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
