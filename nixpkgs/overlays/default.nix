final: prev: { 
  asmjit     = final.callPackage ./asmjit/asmjit.nix {};
  corefreq   = final.linuxPackages_latest.callPackage ./corefreq/corefreq.nix {};
  cozette    = final.callPackage ./cozette/cozette.nix {};
  eli5       = final.callPackage ./eli5/eli5.nix { pythonPackages = final.python39Packages; };
  librewolf  = final.callPackage ./librewolf/librewolf.nix { };
  linasm     = final.callPackage ./linasm/linasm.nix { };
  mathpresso = final.callPackage ./mathpresso/mathpresso.nix {};
  pmlb       = final.callPackage ./pmlb/pmlb.nix { pythonPackages = final.python39Packages; };
  zenpower   = final.callPackage ./zenpower/zenpower.nix { kernel = final.linuxPackages_latest.kernel; };
}
