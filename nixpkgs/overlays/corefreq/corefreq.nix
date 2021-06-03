{ stdenv
, lib
, fetchFromGitHub
, linuxHeaders
, kernel
}:
stdenv.mkDerivation rec {
  pname = "corefreq";
  version = "1.85";

  src = fetchFromGitHub {
    repo = "CoreFreq";
    owner = "cyring";
    rev = "${version}";
    sha256 = "sha256-883XLgZF34WXlui1j1uug9rREeVOfG1x/z+NaKfQFgc=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  buildPhase = ''
    export KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    export PREFIX="$out"
    make
    '';

  installPhase = ''
    export KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    make install DESTDIR=$out
    '';

  meta = with lib; {
    description = "CPU monitoring software with BIOS like functionalities.";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ xxx ];
  };
}
