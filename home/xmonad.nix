{config, pkgs, lib, ...}:
{
  services.taffybar.enable = true;
  services.screen-locker = {
    enable = true;
    # inactiveInterval = 30;
    lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
    xautolock.extraOptions = [
      "Xautolock.killer: systemctl suspend"
    ];
    xautolock.enable = true;
  };
  xsession ={
    enable = true;
    importedVariables = [ "GDK_PIXBUF_ICON_LOADER" ];
    preferStatusNotifierItems = true;
  };
  programs.autorandr = {
    enable = true;
  };
  services.picom = {
    enable = true;
    fade = true;
    vSync = true;
    # experimentalBackends = true;
    fadeDelta = 5;
    backend="glx";
  };

}
