{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  fonts.fontconfig.enable = true;
  # I don't really want to manage xmonad with home-manager
  # Having to switch home-configs everytime I want to configure xmonad (and experimenting with stuff) is really annoyoing

  # It seems that, if you write another "home.packages" in a module
  # these get merged somehow..
  home.packages = with pkgs; [
    cachix
    cmus
    # conky
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
    obs-studio
    pandoc

    poppler_utils # for pdf stuff

    # rlwrap # for wrapping sqlite..
    
    signal-desktop
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


    # citation management / pdf-reader
    zotero
    papis

    # scrot # screenshots
    # slop # better screen selectoin
    # niv

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
    tenacity
    
    # hello
    hledger
    hledger-ui

    tlwg
    
    freetube
    anki
    nixfmt
    ripgrep
    fd
    graphviz
    tldr
    shotcut
    screenkey
    
    # even though I use pipewire, I use pulseaudio for audio control
    pulsemixer
    pulseaudio # for pactl 
    playerctl

    
    blanket # whitenoise
    fstl
    simple-scan

    # python is needed for stuff
    python3
    gcc

    # more browsers
    brave
    nyxt

    itd # pinetime app
    # rust editors
    helix
    # this doesn't really fit with my style tbh.. I like helix more
    lapce

    
    powertop

    termonad
    # prorietary stuff 
    slack
    spotify
    discord

    # spelling - move to emacs later
    # wordnet
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))

    pass

    # other tools
    zip
    unzip
    libnotify
    gnuplot

    # pdf
    sioyek
    libsForQt5.okular

    # common lisp (impure)
    sbcl

    # ldtk
    ldtk

    # airshipper (games)
    airshipper
  ];
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # optional for nix flakes support in home-manager 21.11, not required in home-manager unstable or 22.05

  
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    # TODO make config for this later
  };


}
