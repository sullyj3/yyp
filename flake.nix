{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = import ./shell.nix { inherit pkgs; };
        packages.default = pkgs.callPackage ./yyp.nix {};
    })
    //
    rec {
      overlay = final: prev: {
        yyp = final.callPackage ./yyp.nix {};
      };
      overlays.default = overlay;
    };
}
