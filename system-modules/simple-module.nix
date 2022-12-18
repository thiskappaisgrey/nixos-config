{config, pkgs, lib, ...}:
let
  cfg = config.ttsystem.simple-module;
in
with pkgs.lib;
{
  options = {
    ttsystem.simple-module = {
      enable = mkEnableOption "enables the simple config";
      #   mkOption {
      #   default = false;
      #   type = with pkgs.lib.types; bool;
      #   description = "Enable simple config";
      # };
      
    };
  };
  config = {
     # environment =     mkIf cfg.enable {}; 
  };
  
}
