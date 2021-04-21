{ stdenv
, lib
, fetchFromGitHub
, linuxHeaders
, kernel
}:
stdenv.mkDerivation rec {
  pname = "corefreq";
  version = "1.83";

  src = fetchFromGitHub {
    repo = "CoreFreq";
    owner = "cyring";
    rev = "${version}";
    sha256 = "080yyjlva7ldkxyydn0gzxkkmxnqdd6961vf684slbk4jnaxp6m3";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  buildPhase = ''
    export KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    make
    '';

  installPhase = ''
    export KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    export PREFIX="$out"
    make install
    '';

  meta = with lib; {
    description = "CPU monitoring software with BIOS like functionalities.";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ xxx ];
  };
}
