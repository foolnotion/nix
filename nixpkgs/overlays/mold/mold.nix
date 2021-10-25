{ lib, stdenv, fetchFromGitHub, tbb, xxHash, zlib, mimalloc, openssl, git, clang_10, make }:

stdenv.mkDerivation rec {
  pname = "mold";
  version = "0.1.1";

  src = fetchFromGitHub {
    repo = "mold";
    owner = "rui314";
    rev = "v${version}";
    sha256 = "sha256-nq59hDfHqg+OHxgbco/Z22Y97Jrkz71k0hBBBOFyOr0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ clang_10 make ];

  buildInputs = [ tbb xxHash zlib mimalloc openssl git ];

  buildPhase = ''
    ASAN=1 make -j
  '';

  meta = with lib; {
    description = "mold is a high performance drop-in replacement for existing unix linkers";
    homepage = "https://github.com/rui314/mold";
    license = licenses.agpl3;
    platforms = platforms.all;
  };
}
