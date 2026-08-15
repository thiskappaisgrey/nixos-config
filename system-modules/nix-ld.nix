{ config, pkgs, lib, ... }:
let cfg = config.ttsystem.nix-ld;
in with lib; {
  options = { ttsystem.nix-ld = { enable = mkEnableOption "Enable nix-ld"; }; };
  config = mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
        fuse3
        icu
        nss
        openssl.dev
        curl
        expat
        pkg-config

        # Chromium / Playwright
        glib
        nspr
        dbus
        cups.lib
        libxcb
        libxkbcommon
        alsa-lib
        mesa
        xorg.libX11
        xorg.libXext
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXfixes
        xorg.libXrandr
        cairo
        pango
        atk
        at-spi2-atk
        at-spi2-core
      ];
    };
  };
}
