{ config, lib, pkgs, ... }:
{
  # Top-level Tools for Haskell development 
  home.packages = with pkgs; [
    # I install ghc on a per-project basis anyways
    # ghc installation is required for cabal to work
    ghc
    # ghcid
    cabal-install
    stack
  ];
}
