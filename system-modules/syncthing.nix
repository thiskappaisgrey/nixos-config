{config, pkgs, lib, ...}:
let
  cfg = config.ttsystem.syncthing;
in
with lib;
{
  options = {
    ttsystem.syncthing = {
      enable = mkEnableOption "My Syncthing config";
    };
  };
  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      user = "thanawat";
      dataDir = "/home/thanawat";
      configDir = "/home/thanawat/.config/syncthing";
    };

  };
  
}
