{ config, lib, pkgs, ... }:
{
  # Top-level Tools for Haskell development 
  home.packages = with pkgs; [
    ghc
    # ghcid
    cabal-install
    stack
  ];
}
