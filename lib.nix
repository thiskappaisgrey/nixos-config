# stolen from hlissner dotfiles .. you can actually extend lib in nix, didn't know that
{ self, lib, ...}:
let
  inherit (builtins) attrValues readDir pathExists concatLists;
  inherit (lib) id mapAttrsToList filterAttrs hasPrefix hasSuffix nameValuePair removeSuffix;
in
rec {
  # test function
  allFileNames = dir: (readDir dir);
  # code inspired(basically copied) from hlisnner dotfiles
  
  # map all modules in a directory - non-recursively


  # readDir outputs an attrSet with file types, which can be one of
  # The possible values for the file type are "regular", "directory", "symlink" and "unknown".
  # goal is to get a list of all the regular files and map a function over them
  mapModules = fn: dir:
    let
      # list of all nix modules, for example
      # [ "mobile-debugging.nix" "thinkpad-power.nix" "xmonad-de.nix" ]
      toPath = file: ./. +  "/${builtins.baseNameOf dir}/${file}";
      modules = mapAttrsToList (moduleName: moduleType: toPath moduleName) (filterAttrs (name: value: value == "regular" && (name != "default.nix") && (hasSuffix ".nix" name)) (readDir dir));
    in
      map fn modules;
  # mapModules = fn: dir:
  #   let
  #     # list of all nix modules, for example
  #     # [ "mobile-debugging.nix" "thinkpad-power.nix" "xmonad-de.nix" ]
  #     toPath = file: "${toString dir}/${file}";
  #     modules = mapAttrs fn (filterAttrs (name: value: value == "regular" && (name != "default.nix") && (hasSuffix ".nix" name)) (readDir dir));
  #   in
  #     modules;
      
}
