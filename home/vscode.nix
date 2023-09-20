{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      mkhl.direnv
      maximedenes.vscoq
      # gregoire.dance
      haskell.haskell
    ];
  };
}
