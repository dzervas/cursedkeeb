{ pkgs ? import <nixpkgs> {} }: let
  buildInputs = with pkgs; [
    stdenv.cc.cc.lib
    expat
    libGL
    xorg.libX11
    zlib

    flip-link
    cargo-make
  ];
  lib-path = with pkgs; lib.makeLibraryPath buildInputs;
in pkgs.mkShell {
  inherit buildInputs;

  shellHook = ''
    export LD_LIBRARY_PATH=${lib-path}
    echo "Welcome to the build123d development environment!"
  '';
}
