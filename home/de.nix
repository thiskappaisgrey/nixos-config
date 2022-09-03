{ config , pkgs , lib , ... }:
# Desktop environment stuff
{
  services.picom = {
    enable = true;
    fade = true;
    vSync = true;
    experimentalBackends = true;
    fadeDelta = 5;
    backend="glx";
  };
  home.packages = with pkgs; [
    pcmanfm # file manager
    pkgs.gnome3.adwaita-icon-theme
    hicolor-icon-theme

    # Bar
    taffybar
    haskellPackages.status-notifier-item


    # applets
    caffeine-ng
    flameshot
    networkmanagerapplet
    pasystray

    # for arbtt tools
    haskellPackages.arbtt
  ];
  xsession ={
    enable = true;
    importedVariables = [ "GDK_PIXBUF_ICON_LOADER" ];
    preferStatusNotifierItems = true;
  };

  # services.xembed-sni-proxy.enable = true;
  services.taffybar.enable = true;

  services.screen-locker = {
    enable = true;
    inactiveInterval = 30;
    lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
    # xautolockExtraOptions = [
    #   "Xautolock.killer: systemctl suspend"
    # ];
  };

}
