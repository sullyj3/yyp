{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  packages = [ 
    pkgs.shellcheck
    pkgs.bats 
  ];
}
