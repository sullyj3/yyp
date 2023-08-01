{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { self, flake-parts, ... }@inputs:
  flake-parts.lib.mkFlake { inherit inputs; } {
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    perSystem = {pkgs, ...}: {
      devShells.default = import ./shell.nix { inherit pkgs; };
      packages.default = pkgs.callPackage ./yyp.nix {};
    };
    flake = {
      overlays.default = final: prev: {
        yyp = prev.callPackage ./yyp.nix {};
      };
    };
  };
}
