{ config, pkgs, lib, ... }:
let cfg = config.tthome.home;
in {
  options = {
    tthome.home = { enable = lib.mkEnableOption "Enable my home config"; };
  };
  config = lib.mkIf cfg.enable {
    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # fonts.fontconfig.enable = true;
    # I don't really want to manage xmonad with home-manager
    # Having to switch home-configs everytime I want to configure xmonad (and experimenting with stuff) is really annoyoing

    # It seems that, if you write another "home.packages" in a module
    # these get merged somehow..
    home.packages = with pkgs; [
      cachix
      element-desktop # matrix client
      exercism
      feh
      file
      fontpreview
      fzf
      gimp
      gnumake
      imagemagick
      # languagetool
      libqalculate

      lsd
      pandoc
      poppler_utils # for pdf stuff

      signal-desktop
      sxiv

      tldr
      tmux
      usbutils
      # xournalpp

      zathura
      # citation management / pdf-reader
      zotero

      hledger
      hledger-ui

      tlwg # thai font

      ripgrep
      fd
      graphviz

      tldr

      # even though I use pipewire, I use pulseaudio for audio control
      pulsemixer
      playerctl

      blanket # whitenoise
      fstl
      simple-scan

      # more browsers
      brave
      nyxt

      itd # pinetime app

      powertop

      # termonad
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
      gnuplot

      # pdf
      sioyek

      sqlite
      nerdfonts

    ];
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    fonts.fontconfig.enable = true;
    # optional for nix flakes support in home-manager 21.11, not required in home-manager unstable or 22.05

    home.file = {
      helix = {
        source = config.lib.file.mkOutOfStoreSymlink
          "/home/thanawat/.dotfiles/home/impure/helix";
        target = "/home/thanawat/.config/helix";
      };
    };

  };
}
