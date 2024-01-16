{ config, pkgs, lib, ... }:
# Desktop environment stuff
{
  services.dunst.enable = true;

  gtk = {
    enable = true;
    # theme = {
    #   package = pkgs.colloid-gtk-theme;
    #   name = "Colloid";
    # };
    iconTheme = {
      name = "Qogir";
      package = pkgs.qogir-icon-theme;
    };
  };
  home.packages = with pkgs; [
    pcmanfm # file manager
    pkgs.gnome.adwaita-icon-theme
    hicolor-icon-theme
    # nerdfonts
    # Bar

    betterlockscreen

    # applets
    networkmanagerapplet
    pasystray

    brightnessctl

    # video
    mpv
    yt-dlp

    # tor
    tor-browser-bundle-bin

    wezterm
    texlab

    # download dramas
    dra-cla

    pdfpc
    wlsunset
  ];

  services.wlsunset = {
    enable = true;
    latitude = "34";
    longitude = "119";
  };

  # These files (Xmonad / Taffybar config) are "impure" configs b/c I
  # change them a lot.. I just want them symlinked without having to
  # have them managed by home-manager
  home.file = {
    sioyek.source = config.lib.file.mkOutOfStoreSymlink
      "/home/thanawat/.dotfiles/home/impure/sioyek/";
    sioyek.target = "/home/thanawat/.config/sioyek";

    alacritty.source = config.lib.file.mkOutOfStoreSymlink
      "/home/thanawat/.dotfiles/home/impure/alacritty/";
    alacritty.target = "/home/thanawat/.config/alacritty";
  };

}
