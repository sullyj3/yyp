{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachSystem ["x86_64-linux"] (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.default = pkgs.mkShell {
        packages = [ 
          pkgs.shellcheck
          pkgs.bats 
        ];
      };

      packages.default = pkgs.stdenv.mkDerivation {
        pname = "yyp";
        version = "0.1.0";
        src = ./src/yyp.sh;
        phases = [ "installPhase" ];

        installPhase = ''
          mkdir -p $out/bin
          cp $src $out/bin/yyp
          chmod +x $out/bin/yyp
        '';

        meta = with pkgs.lib; {
          description = "yyp - copy quicker";
          license = licenses.mit;
        };
      };
    });
}
