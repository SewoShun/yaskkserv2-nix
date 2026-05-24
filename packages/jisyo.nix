{
  lib,
  stdenv,
  symlinkJoin,
  skkDictionaries,
  yaskkserv2,
}:
lib.makeOverridable (
  { dicts }:
  stdenv.mkDerivation {
    pname = "yaskkserv-jisyo";
    version = yaskkserv2.version;

    src = symlinkJoin {
      name = "skkDictionaries";
      paths = dicts;
    };

    buildPhase = ''
      ${yaskkserv2}/bin/yaskkserv2_make_dictionary --dictionary-filename yaskkserv.jisyo share/skk/*
    '';

    installPhase = ''
      mkdir -p $out/share/skk/
      cp yaskkserv.jisyo $out/share/skk/
    '';
  }
) { dicts = [ skkDictionaries.l ]; }
