{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    flake-utils.url = "github:numtide/flake-utils";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    overlays = [
        (import ./overlays/default.nix)
        inputs.neovim-nightly.overlay
    ];
  in 
  inputs.flake-utils.lib.eachDefaultSystem (system:
  {
    legacyPackages = inputs.nixpkgs.legacyPackages.${system};
  }
  ) //
  {
    homeConfigurations = {
      bogdb = inputs.home-manager.lib.homeManagerConfiguration {
        stateVersion = "21.05";
        system = "x86_64-linux";
        homeDirectory = "/home/bogdb";
        username = "bogdb";

        configuration = { pkgs, ... }:
        {
          nixpkgs.config = import ./configs/nix/config.nix; 
          nixpkgs.overlays = overlays;

          programs.home-manager.enable = true;

          imports = [
            ./modules/neovim.nix
            ./modules/packages.nix
          ];
          home.sessionVariables = {
            EDITOR = "nvim";
            TCLLIBPATH = "~/.local/share/tk-themes";
          };
          programs.bash = {
            enable = true;
            shellAliases = {
              kd = "kitty --detach";
            };
          };
          programs.vscode = {
            enable = true;
            package = pkgs.vscode;
            extensions = with pkgs.vscode-extensions; [
              xaver.clang-format
              ms-vscode.cpptools
            ];
          };
          programs.exa.enable = true;
          programs.lazygit.enable = true;

        }; # configuration 
      }; 
    }; # homeConfigurations
    bogdb = self.homeConfigurations.bogdb.activationPackage;
    defaultPackage.x86_64-linux = self.bogdb;
  }; #outputs
}

