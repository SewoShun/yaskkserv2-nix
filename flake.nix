{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    cargo2nix.url = "github:cargo2nix/cargo2nix/release-0.12";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        {
          pkgs,
          system,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [ inputs.rust-overlay.overlays.default ];
          };

          packages =
            let
              yaskkserv2 = pkgs.stdenv.mkDerivation {
                pname = "yaskkserv2";
                version = "0.1.7";
                src = fetchTarball {
                  url = "https://github.com/wachikun/yaskkserv2/releases/download/0.1.7/yaskkserv2-0.1.7-x86_64-unknown-linux-gnu.tar.gz";
                  sha256 = "sha256:0189hvkpkyk9bpqngll3mwxz0qrqiv1f652dfrm84kp8430nfrys";
                };

                nativeBuildInputs = with pkgs; [
                  autoPatchelfHook
                  libgcc
                ];
                buildPhase = ''
                  mkdir -p $out/bin
                  cp yaskkserv2 yaskkserv2_make_dictionary $out/bin/
                '';
              };

              jisyo = pkgs.lib.makeOverridable (
                { dicts }:
                pkgs.stdenv.mkDerivation {
                  name = "yaskkserv-jisyo";
                  src = pkgs.symlinkJoin {
                    name = "skkDictionaries";
                    paths = dicts;
                  };
                  buildPhase = ''
                    mkdir -p $out/share/skk/
                    ${yaskkserv2}/bin/yaskkserv2_make_dictionary --dictionary-filename yaskkserv.jisyo share/skk/*
                    cp yaskkserv.jisyo $out/share/skk/
                  '';
                }
              ) { dicts = [ pkgs.skkDictionaries.l ]; };
            in
            {
              default = yaskkserv2;
              inherit jisyo yaskkserv2;
            };

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
            ];
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              rustfmt.enable = true;
              taplo.enable = true;
            };
          };
        };
    };
}
