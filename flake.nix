{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    treefmt-nix.url = "github:numtide/treefmt-nix";
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
          inputs.home-manager.flakeModules.home-manager
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
