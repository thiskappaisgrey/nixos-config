{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    # extensions = with pkgs.vscode-extensions; [
    #   bbenoist.nix
    #   mkhl.direnv
    #   maximedenes.vscoq
    #   # gregoire.dance
    #   haskell.haskell
    # ];
  };
}
