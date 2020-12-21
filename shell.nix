{ ... }:
let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };
in pkgs.stdenv.mkDerivation {
  name = "brianthicks.com";
  buildInputs = [ pkgs.git pkgs.hugo ];
}
