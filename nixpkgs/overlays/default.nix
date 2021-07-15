final: prev: { 
  asmjit     = final.callPackage ./asmjit/asmjit.nix {};
  corefreq   = final.linuxPackages_latest.callPackage ./corefreq/corefreq.nix {};
  cozette    = final.callPackage ./cozette/cozette.nix {};
  eli5       = final.callPackage ./eli5/eli5.nix { pythonPackages = final.python39Packages; };
  librewolf  = final.callPackage ./librewolf/librewolf.nix { };
  linasm     = final.callPackage ./linasm/linasm.nix { };
  mathpresso = final.callPackage ./mathpresso/mathpresso.nix {};
  mold       = final.callPackage ./mold/mold.nix {
                   fetchFromGitHub = final.fetchFromGitHub;
                   make = final.automake;
               };
  pareto     = final.callPackage ./pareto/pareto.nix { fetchFromGitHub = final.fetchFromGitHub; };
  pmlb       = final.callPackage ./pmlb/pmlb.nix { pythonPackages = final.python39Packages; };
  zenpower   = final.callPackage ./zenpower/zenpower.nix { kernel = final.linuxPackages_latest.kernel; };
  zenmonitor = final.callPackage ./zenmonitor/zenmonitor.nix {};
  taskflow   = final.callPackage ./taskflow/taskflow.nix { fetchFromGitHub = final.fetchFromGitHub; };

  #pandas     = prev.pandas.override { doCheck = false; };
}
