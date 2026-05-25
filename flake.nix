{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs.follows = "nixpkgs";
    systems.url = "github:nix-systems/default";
    systems.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        flake-parts-lib,
        self,
        ...
      }:
      let
        inherit (flake-parts-lib) importApply;
      in
      {
        systems = import inputs.systems;

        imports = [
          inputs.treefmt-nix.flakeModule
        ];

        flake.homeModules.yaskkserv2 = importApply ./modules/homeModule.nix { inherit self; };

        perSystem =
          {
            pkgs,
            ...
          }:
          {
            packages =
              let
                yaskkserv2 = pkgs.callPackage ./packages/yaskkserv2.nix { };
                jisyo = pkgs.callPackage ./packages/jisyo.nix { inherit yaskkserv2; };
              in
              {
                default = yaskkserv2;
                inherit jisyo yaskkserv2;
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
      }
    );
}
