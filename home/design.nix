{ config, pkgs, lib, ... }:
let cfg = config.tthome.design;
in {
  options = {
    tthome.design = { enable = lib.mkEnableOption "Enable Design tools"; };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ kicad freecad openscad ];
  };
}

