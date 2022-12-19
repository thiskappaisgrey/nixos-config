# for my xmonad de options
# never use pkgs.lib.. or else infinite recursion! 
{config, pkgs, lib, ...}:
let
  cfg = config.ttsystem.xmonad-de;
in
{
  options = {
    ttsystem.xmonad-de = {
      enable = lib.mkOption {
        default = false;
        type = with lib.types; bool;
        description = "Enable Xmonad DE";
      };
      # enable for 
      diskEncryptautoLogin = lib.mkOption {
        default = false;
        type = with lib.types; bool;
        description = "Enables autologin for disk encrypted systems";
      };
      
    };
  };
  # config = {};
  config =  lib.mkIf cfg.enable
    {
      services.xserver.windowManager.xmonad = # lib.mkIf cfg.enable
        {
          enable = true;
          enableContribAndExtras = true;
        };

    services.xserver.displayManager = lib.mkIf cfg.diskEncryptautoLogin {
      autoLogin.enable = true;
      autoLogin.user = "thanawat";
      defaultSession = "none+xmonad";
      lightdm.enable = true;
    };
  };
  
}
