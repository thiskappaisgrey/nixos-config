{ config, pkgs, ... }:

{
  imports = [ # ./emacs/default.nix
              ./shell ./haskell.nix ./de.nix  ./unity.nix ];
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
    mypaint
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
    zotero

    # scrot # screenshots
    # slop # better screen selectoin
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

    itd # pinetime app

    helix

    termonad
    # prorietary stuff 
    slack
    spotify
    discord
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
