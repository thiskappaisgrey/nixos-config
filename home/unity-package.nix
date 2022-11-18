{ pkgs ? import <nixpkgs> { # overlays = [ (final: prev: { openssl = prev.openssl_1_1; }) ]; 
} }:
(let
  oldPkgs = import (builtins.fetchGit {
      # Descriptive name to make the store path easier to identify                
      name = "my-old-revision";                                                 
      url = "https://github.com/NixOS/nixpkgs/";                       
      ref = "refs/heads/nixpkgs-unstable";                     
      rev = "ff8b619cfecb98bb94ae49ca7ceca937923a75fa";                                           }) {};
  my-openssl = oldPkgs.openssl;
in
  (pkgs.callPackage  ./unityhub.nix { openssl_1_1 = my-openssl; }).env)
