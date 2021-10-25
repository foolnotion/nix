{ 
  allowUnsupportedSystem = true; 
  allowUnfree = true;
  allowBroken = true;
  permittedInsecurePackages = [
    "openssl-1.0.2u"
  ];
  input-fonts.acceptLicense = true;

  nixpkgs.localSystem = {
    gcc.arch = "znver2";
    gcc.tune = "znver2";
    system = "x86_64-linux";
  };
}
