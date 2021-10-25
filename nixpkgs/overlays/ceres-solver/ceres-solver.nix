{ lib, stdenv
, eigen
, fetchFromGitHub 
, cmake
, gflags
, glog
, runTests ? false
}:

# gflags is required to run tests
assert runTests -> gflags != null;

stdenv.mkDerivation rec {
  pname = "ceres-solver";
  version = "2.0.0";

  src = fetchFromGitHub {
    repo   = "ceres-solver";
    owner  = "ceres-solver";
    rev    = "2a2b9bd6fa2a0ee62f58dceb786cb2dc3eb37630";
    sha256 = "sha256-jS3XJdVuq/ZGPKqGx3TH87159Mje4CUda4YJhhUmrKs=";
  };

  nativeBuildInputs = [ cmake ];
  enableParallelBuilding = true;
  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" "-DCXX11=ON" "-DTBB=OFF" "-DOPENMP=OFF" "-DBUILD_SHARED_LIBS=OFF" "-DBUILD_EXAMPLES=FALSE" "-DBUILD_TESTING=FALSE" ];

  buildInputs = [ eigen glog ]
    ++ lib.optional runTests gflags;

  # The Basel BUILD file conflicts with the cmake build directory on
  # case-insensitive filesystems, eg. darwin.
  preConfigure = ''
    rm BUILD
  '';

  doCheck = runTests;

  checkTarget = "test";

  meta = with lib; {
    description = "C++ library for modeling and solving large, complicated optimization problems";
    license = licenses.bsd3;
    homepage = "http://ceres-solver.org";
    maintainers = with maintainers; [ giogadi ];
    platforms = platforms.unix;
  };
}

