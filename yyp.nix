{ stdenv, lib }:
stdenv.mkDerivation {
  pname = "yyp";
  version = "0.1.0";
  src = ./src/yyp.sh;
  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/yyp
    chmod +x $out/bin/yyp
  '';

  meta = with lib; {
    description = "yyp - copy quicker";
    license = licenses.mit;
  };
}
