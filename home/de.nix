{ config , pkgs , lib , ... }:
# Desktop environment stuff
{
  services.picom = {
    enable = true;
    fade = true;
    vSync = true;
    # experimentalBackends = true;
    fadeDelta = 5;
    backend="glx";
  };
  services.dunst.enable = true;
  gtk = {
    enable = true;
    theme = {
      package = pkgs.graphite-gtk-theme;
      name  = "graphite-gtk-theme";
    };
  };
  home.packages = with pkgs; [
    pcmanfm # file manager
    pkgs.gnome.adwaita-icon-theme
    hicolor-icon-theme
    nerdfonts
    # Bar
    taffybar
    haskellPackages.status-notifier-item
    betterlockscreen


    # applets
    caffeine-ng
    flameshot
    networkmanagerapplet
    pasystray

    # for arbtt tools
    haskellPackages.arbtt

    rofi
    rofi-pass
    rofimoji
    brightnessctl

    # autorandr

    # email
    thunderbird
  ];
  xsession ={
    enable = true;
    importedVariables = [ "GDK_PIXBUF_ICON_LOADER" ];
    preferStatusNotifierItems = true;
  };


  # TODO define different autorandr profiles for my different systems.. just 
  programs.autorandr = {
    enable = true;
  };
  # services.xembed-sni-proxy.enable = true;
  services.taffybar.enable = true;

  # TODO rewrite, maybe just write my own
  services.screen-locker = {
    enable = true;
    # inactiveInterval = 30;
    lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
    xautolock.extraOptions = [
      "Xautolock.killer: systemctl suspend"
    ];
    xautolock.enable = true;
  };

  # xdg.mimeApps = {
  #   enable = true;
  #   defaultApplications = {
  #     "unityhub" = [ "unityhub.dest"]
  #   };
  # };

}
