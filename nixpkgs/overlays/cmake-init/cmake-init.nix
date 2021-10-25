{ lib, pythonPackages, cmake, git, clang-tools, cppcheck, lcov, codespell, python, fetchFromGitHub }:
let
  buildPythonPackage = pythonPackages.buildPythonPackage;
  fetchPypi = pythonPackages.fetchPypi;
in
buildPythonPackage rec {
    pname = "cmake-init";
    version = "0.21.2";

    src = fetchFromGitHub {
      repo = "cmake-init";
      rev = "v${version}";
      owner = "friendlyanon";
      sha256 = "sha256-sAefbv1cIpIXqMXQz9t8sK6qMxN++E0lvvjd/egdAJ0=";
    };

    #src = fetchPypi {
    #  inherit pname version;

    #  sha256 = "sha256-ywWAsn/fCA6SIH7JDq0rhiLXKOJkxrEG1BnAIcWrTdE=";
    #};

    nativeBuildInputs = [ python git cmake ];
    buildInputs = [ cmake git clang-tools cppcheck lcov codespell ]; 

    doCheck = false;
    dontUseCmakeConfigure = true;

    buildPhase = ''
      cd ./package
      python setup.py build
      '';
    installPhase = ''
      cd ./package
      python setup.py install
      '';

    #patchPhase = ''
    #  sed -i 's/..\/cmake-init/.\/cmake-init/g' setup.py
    #  '';


    meta = with lib; {
      homepage = "https://github.com/friendlyanon/cmake-init";
      description = "Opinionated CMake project initializer to generate CMake projects that are FetchContent ready, separate consumer and developer targets, provide install rules with proper relocatable CMake packages and use modern CMake (3.14+)";
      license = licenses.gpl3;
    };
}
