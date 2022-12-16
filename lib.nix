# stolen from hlissner dotfiles .. you can actually extend lib in nix, didn't know that
{ self, lib, ...}:
let
  inherit (builtins) attrValues readDir pathExists concatLists;
  inherit (lib) id mapAttrsToList filterAttrs hasPrefix hasSuffix nameValuePair removeSuffix;
  inherit (self.attrs) mapFilterAttrs;
in
rec {
  # test function
  allFileNames = dir: (readDir dir);
}
