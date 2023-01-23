{config, pkgs, lib, ...}:
let
  cfg = config.ttsystem.zoom;
  in
with lib;
{
  options = {
    ttsystem.zoom = {
      enable = mkEnableOption "Enable zoom in firejail wrapped binary";
      };
    };
  config = mkIf cfg.enable {
    # firejail for zoom
    programs.firejail = {
      enable = true;
      wrappedBinaries = {
        zoom = {
          executable = let in "${lib.getBin pkgs.zoom-us}/bin/zoom-us";
          profile = "${pkgs.firejail}/etc/firejail/zoom.profile";
        };
      };
    };

    };
}
