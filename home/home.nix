{ config, pkgs, ... }:

{
  imports = [ ./emacs ./shell ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  # home.username = "thanawat";
  # home.homeDirectory = "/home/thanawat";
  fonts.fontconfig.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  # home.stateVersion = "18.09";
  # programs.emacs = { enable = true; };
  # nixpkgs.overlays = [
  #   (self: super: {
  #     airshipper = super.pkgs.callPackage ./airshipper.nix {};
  #   })

  # ];
  # TODO Move over the Xmonad config to home-manager
  # TODO add gtk config with home-manager
  # gtk.iconTheme = {
  #   package = pkgs.gnome3.adwaita-icon-theme;
  #   name = "adwaita";
  # };
  services.picom = {
    enable = true;
    fade = true;
    vSync = true;
    experimentalBackends = true;
    fadeDelta = 5;
    backend="glx";
  };
  services.emacs.enable = true;
  services.emacs.defaultEditor = true;
  # services.status-notifier-watcher.enable = true;
  # services.caffeine.enable = true;
  # services.flameshot.enable = true;
  # services.network-manager-applet.enable= true;
  # services.blueman-applet.enable = true;
  xsession ={
    enable = true;
    importedVariables = [ "GDK_PIXBUF_ICON_LOADER" ];
    preferStatusNotifierItems = true;
  };
  services.taffybar.enable = true;
  services.xembed-sni-proxy.enable = true;
  # services.keybase.enable = true;
  services.kbfs.enable = true;
  # TODO manage doom emacs using home manager too?????
  home.packages = with pkgs; [
    akira-unstable
    pkgs.gnome3.adwaita-icon-theme
    hicolor-icon-theme
    cachix
    cmus
    conky
    element-desktop
    exercism
    feh
    ffmpeg
    file
    fontpreview
    fzf
    gimp
    gnumake
    imagemagick
    languagetool
    libqalculate
    libreoffice
    lsd # next gen ls command
    mp3info
    mypaint
    obs-studio
    pandoc
    pcmanfm # file manager

    poppler_utils # for pdf stuff

    rlwrap # for wrapping sqlite..
    # airshipper

    signal-desktop
    # starship
    sxiv
    tldr
    tmux
    usbutils
    xclip
    xorg.xmodmap
    xournalpp
    xorg.xwininfo
    youtube-dl
    ytfzf
    ytmdl
    zathura
    zotero

    scrot # screenshots
    slop # better screen selectoin
    niv

    # Music stuff
    guitarix
    lingot # tuner
    # lmms
    ardour
    qjackctl
    # audacity
    hydrogen
    x42-avldrums
    rubberband

    alsa-utils # for volume control
    # hello
    pasystray

    tlwg
    caffeine-ng
    freetube
    anki
    nixfmt
    ripgrep
    fd
    graphviz
    tldr
    # try taffybar again
    taffybar
    haskellPackages.status-notifier-item
    # haskellPackages.gtk-sni-tray
    networkmanagerapplet
    shotcut
    screenkey
    
    # audio control
    # even though I use pipewire, I use pulseaudio for audio control
    pulsemixer
    pulseaudio
    playerctl
    flameshot
    vial

    blanket # whitenoise
    fstl
    simple-scan

    # prorietary stuff 
    slack
    spotify
    discord
    
  ];
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # optional for nix flakes support in home-manager 21.11, not required in home-manager unstable or 22.05
  # programs.direnv.nix-direnv.enableFlakes = true;
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    # TODO make config for this later
  };
  
  # programs.firejail = {
  #   enable = true;
  #   wrappedBinaries = {
  #     zoom = {
  #       executable = "${lib.getBin pkgs.zoom-us}/bin/zoom-us";
  #       profile = "${pkgs.firejail}/etc/firejail/zoom.profile";
  #     };
  #   };
  # };
}
