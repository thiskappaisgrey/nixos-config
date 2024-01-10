{ config, pkgs, lib, ... }:
let cfg = config.tthome.de.audio;
in {
  options = {
    tthome.de.audio = { enable = lib.mkEnableOption "Enable audio apps"; };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ardour
      qjackctl
      hydrogen
      x42-avldrums
      rubberband
      tenacity

      guitarix
      lingot # tuner
    ];
  };
}
