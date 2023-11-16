{ config, pkgs, lib, ... }:
let cfg = config.tthome.de.video-editing;
in {
  options = {
    tthome.de.video-editing = {
      enable = lib.mkEnableOption "Enable drawing apps";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      obs-studio

      shotcut
      screenkey
    ];
  };
}
