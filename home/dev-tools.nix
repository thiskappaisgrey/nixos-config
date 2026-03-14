{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.tthome.dev-tools;
in
{
  options = {
    tthome.dev-tools = {
      enable = lib.mkEnableOption "Enable Developer Tools";
      # TODO: Make enable options for each lang

      # nix-enable =
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      uv
      gcc
      helix

      # janet and other stuff
      janet
      jpm
      lua
      lua-language-server

      zellij

      neovide
      # zed-editor

      nix-init

      nixfmt
      ast-grep

      bat
      # llama-cpp
      foot
      jujutsu

      go
      gopls

      duckdb
      diceware
      numbat
      fuzzel
    ];

    home.file = {
      zellij.source = config.lib.file.mkOutOfStoreSymlink "/home/thanawat/.dotfiles/home/impure/zellij/";
      zellij.target = "/home/thanawat/.config/zellij";
    };

  };

}
