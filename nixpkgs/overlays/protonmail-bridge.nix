self: super:
{    
  protonmail-bridge = super.protonmail-bridge.overrideAttrs (old: rec {    
    version = "1.4.5-1";    
    src = super.fetchurl {    
      url = "https://protonmail.com/download/protonmail-bridge_${version}_amd64.deb";    
      sha256 = "08dqxgq8psmiqr9ziww8nhl8r42ifd8zv0jcdq7in6vcw51iv9wq";    
    };    

    postFixup = let    
      rpath = super.rpath;    
    in ''    
      patchelf \    
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \    
      --set-rpath "${rpath}" \    
      $out/lib/protonmail-bridge    
      substituteInPlace $out/share/applications/protonmail-bridge.desktop \    
      --replace "/usr/" "$out/" \    
      --replace "Exec=protonmail-bridge" "Exec=$out/bin/protonmail-bridge"    
    '';    
  });    
}    
