{ config, lib, pkgs, ... }: {
  # Top-level Tools for Haskell development 
  home.packages = with pkgs; [
    # I install ghc on a per-project basis anyways
    # ghc installation is required for cabal to work
    (haskellPackages.ghcWithPackages
      (pkgs: with pkgs; [ random shh shh-extras ]))
    # ghcid
    cabal-install
    stack
    haskellPackages.haskell-language-server
    haskellPackages.fourmolu
    haskellPackages.cabal-fmt

  ];
}
