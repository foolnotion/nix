final: prev: { 
  asmjit     = final.callPackage ./asmjit/asmjit.nix {};
  ceres-solver = final.callPackage ./ceres-solver/ceres-solver.nix { fetchFromGitHub = final.fetchFromGitHub; };
  cmake-init = final.callPackage ./cmake-init/cmake-init.nix {
    fetchFromGitHub = final.fetchFromGitHub;
    pythonPackages = final.python39Packages;
  };
  corefreq   = final.linuxPackages_latest.callPackage ./corefreq/corefreq.nix {};
  cppsort    = final.callPackage ./cppsort/cppsort.nix { fetchFromGitHub = final.fetchFromGitHub; };
  croaring   = final.callPackage ./croaring/croaring.nix { fetchFromGitHub = final.fetchFromGitHub; };
  cozette    = final.callPackage ./cozette/cozette.nix {};
  #discord    = final.callPackage ./discord/discord.nix {};
  eigen      = final.callPackage ./eigen/eigen.nix {};
  eli5       = final.callPackage ./eli5/eli5.nix { pythonPackages = final.python39Packages; };
  eovim      = final.callPackage ./eovim/eovim.nix { fetchFromGitHub = final.fetchFromGitHub; };
  keyd       = final.callPackage ./keyd/keyd.nix {};
  librewolf  = final.callPackage ./librewolf/librewolf.nix { };
  linasm     = final.callPackage ./linasm/linasm.nix { };
  mathpresso = final.callPackage ./mathpresso/mathpresso.nix {};
  neovim-qt  = final.libsForQt5.callPackage ./neovim-qt/neovim-qt.nix { fetchFromGitHub = final.fetchFromGitHub; };
  pareto     = final.callPackage ./pareto/pareto.nix { fetchFromGitHub = final.fetchFromGitHub; };
  pmlb       = final.callPackage ./pmlb/pmlb.nix { pythonPackages = final.python39Packages; };
  zenpower   = final.callPackage ./zenpower/zenpower.nix { kernel = final.linuxPackages_latest.kernel; };
  zenmonitor = final.callPackage ./zenmonitor/zenmonitor.nix {};
  taskflow   = final.callPackage ./taskflow/taskflow.nix { fetchFromGitHub = final.fetchFromGitHub; };
}
