let
  pkgs = import <nixpkgs> {};
in pkgs.mkShell rec {
  buildInputs = with pkgs; [
    stdenv.cc.cc.lib
    expat
    libGL
    xorg.libX11
    zlib

    flip-link
    cargo-make
    probe-rs-tools
  ];

  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath buildInputs}
  '';
}
