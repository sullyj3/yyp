{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = import ./shell.nix { inherit pkgs; };
      packages.${system}.default = pkgs.callPackage ./yyp.nix {};
      overlays.default = final: prev: {
        yyp = final.callPackage ./yyp.nix {};
      };
    };
}
