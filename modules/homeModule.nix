{ self }:
{
  pkgs,
  lib,
  config,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  cfg = config.services.yaskkserv2;
  jisyo = pkgs.callPackage ../packages/jisyo.nix {
    yaskkserv2 = cfg.package;
    dicts = cfg.jisyo;
  };
in
{
  options.services.yaskkserv2 = {
    enable = lib.mkEnableOption "yaskkserv2";
    jisyo = lib.mkOption {
      default = [ pkgs.skkDictionaries.l ];
      type = lib.types.listOf lib.types.package;
      description = "List of dictionaries used by yaskkserv2";
    };
    package = lib.mkOption {
      default = self.packages.${system}.yaskkserv2;
      type = lib.types.package;
      description = "The yaskkserv2 package to use";
    };
  };

  config = lib.mkIf cfg.enable {
    home.services.yaskkserv2 = {
      process.argv = [
        "${cfg.package}/bin/yaskkserv2"
        "${jisyo}/share/skk/yaskkserv2.jisyo"
        "--no-daemonize"
      ];
    };
  };
}
