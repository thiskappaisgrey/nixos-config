{config, pkgs, lib, ...}:
let
  cfg = config.ttsystem.simple-module;
in
with lib;
{
  options = {
    ttsystem.simple-module = {
      enable = mkEnableOption "enables the simple config";
      
    };
  };
  config = mkIf cfg.enable {
  };
  
}
