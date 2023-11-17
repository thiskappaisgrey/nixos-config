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
      cmus
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
      # libreoffice

      lsd # next gen ls command
      mp3info
      pandoc

      poppler_utils # for pdf stuff

      # rlwrap # for wrapping sqlite..

      signal-desktop
      # image viewer
      sxiv

      tldr
      tmux
      usbutils
      # xournalpp

      # youtube stuff
      youtube-dl
      ytfzf
      ytmdl

      zathura

      # citation management / pdf-reader
      zotero

      # Music stuff
      guitarix
      lingot # tuner

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
      # rust editors
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
      gnuplot

      # pdf
      sioyek

      # ldtk
      ldtk

      sqlite
      nerdfonts

    ];
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    fonts.fontconfig.enable = true;
    # optional for nix flakes support in home-manager 21.11, not required in home-manager unstable or 22.05

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      # TODO make config for this later
    };
    home.file = {
      helix = {
        source = config.lib.file.mkOutOfStoreSymlink
          "/home/thanawat/.dotfiles/home/impure/helix";
        target = "/home/thanawat/.config/helix";
      };
    };

  };
}
