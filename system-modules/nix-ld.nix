{config, pkgs, lib, ...}:
let
  cfg = config.ttsystem.nix-ld;
in
with lib;
{
  options = {
    ttsystem.nix-ld = {
      enable = mkEnableOption "Enable nix-ld";
    };
  };
  config = mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs;[
        stdenv.cc.cc
        zlib
        fuse3
        icu
        zlib
        nss
        openssl
        curl
        expat
      ];
    };
  };
}
