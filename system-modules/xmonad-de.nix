# for my xmonad de options
{config, pkgs, lib, ...}:
let
  cfg = config.ttsystem.xmonad-de;
in
with pkgs.lib;
{
  options = {
    ttsystem.xmonad-de = {
      enable = mkOption {
        default = false;
        type = with pkgs.lib.types; bool;
        description = "Enable Xmonad DE";
      };
      # enable for 
      diskEncryptautoLogin = mkOption {
        default = false;
        type = with pkgs.lib.types; bool;
        description = "Enables autologin for disk encrypted systems";
      };
      
    };
  };
  config = mkIf cfg.enable  {
    services.xserver.windowManager = {
      enable = true;
      enableContribAndExtras = true;
    };
    services.xserver.displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "thanawat";
      defaultSession = "none+xmonad";
      lightdm.enable = true;
    };
  };
  
}
