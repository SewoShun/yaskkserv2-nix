{ self }:
{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.yaskkserv2;
  system = pkgs.stdenv.hostPlatform.system;
in
{
  options.services.yaskkserv2 = {
    enable = lib.mkEnableOption "yaskkserv2";
    jisyo = lib.mkOption {
      default = [ pkgs.skkDictionaries.l ];
      type = lib.types.listOf lib.types.package;
    };
    package = lib.mkOption {
      default = self.packages.${system}.yaskkserv2;
      type = lib.types.package;
    };
  };

  config = lib.mkIf cfg.enable {
    home.services.yaskkserv2 = {
      process.argv = [
        "${cfg.package}/bin/yaskkserv2"
        "${self.packages.${system}.jisyo.override { dicts = cfg.jisyo; }}/share/skk/yaskkserv.jisyo"
        "--no-daemonize"
      ];
    };
  };
}
