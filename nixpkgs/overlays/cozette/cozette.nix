{ lib, fetchzip }:

let
  version = "1.9.3";
in
fetchzip rec {
  name = "Cozette-${version}";

  url = "https://github.com/slavfox/Cozette/releases/download/v.${version}/CozetteFonts.zip";

  sha256 = "8104e960dca987c2836c79215c30141e3203d1cf5ac34e0863fa0549ba235f55";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*.bdf -d $out/share/fonts/misc
    unzip -j $downloadedFile \*.otb -d $out/share/fonts/misc
  '';

  meta = with lib; {
    description = "A bitmap programming font optimized for coziness";
    homepage = "https://github.com/slavfox/cozette";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ brettlyons marsam ];
  };
}
