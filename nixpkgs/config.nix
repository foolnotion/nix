{ 
  allowUnsupportedSystem = true; 
  allowUnfree = true;
  allowBroken = true;
  permittedInsecurePackages = [
    "openssl-1.0.2u"
  ];

  platform.gcc.arch = "znver2";
  platform.kernelArch = "x86_64";
}
