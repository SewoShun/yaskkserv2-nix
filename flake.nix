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
              yaskkserv2 = pkgs.callPackage ./packages/yaskkserv2.nix { };

              jisyo = pkgs.callPackage ./packages/jisyo.nix { inherit yaskkserv2; };
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
