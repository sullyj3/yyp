{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      yyp = import ./yyp.nix { inherit pkgs; };
    in
    {
      devShells.${system}.default = import ./shell.nix { inherit pkgs; };
      packages.${system}.default = yyp;
      # overlays.default = final: prev: {
      #   inherit yyp;
      # };
    };
}
