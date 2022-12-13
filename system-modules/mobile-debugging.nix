{config, pkgs, lib, ...}:
let
  cfg = config.ttsystem.mobile-debugging;
in
with pkgs.lib;
{
  options = {
    ttsystem.mobile-debugging = {
      android-enable = mkOption {
        default = false;
        type = with pkgs.lib.types; bool;
        description = "Enable andriod-debugging";
      };
      apple-enable = mkOption {
        default = false;
        type = with pkgs.lib.types; bool;
        description = "Enable apple-debugging";
      };
    };
  };
  config =  {
    # android
    programs.adb.enable = cfg.android-enable;
    # For iphone
    services.usbmuxd.enable = cfg.apple-enable;
  };
}
