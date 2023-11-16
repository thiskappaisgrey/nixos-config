{ config, pkgs, lib, ... }:
let cfg = config.tthome.de.drawing;
in {
  options = {
    tthome.de.drawing = { enable = lib.mkEnableOption "Enable drawing apps"; };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [

      # drawing
      inkscape
      krita
      rx
      rnote
    ];
  };
}
