{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      yyp = pkgs.stdenv.mkDerivation {
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
    in
    {
      devShells.${system}.default = import ./shell.nix { inherit pkgs; };
      packages.${system}.default = yyp;
      # overlays.default = final: prev: {
      #   inherit yyp;
      # };
    };
}
