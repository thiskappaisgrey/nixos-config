{ config, lib, pkgs, ... }:

{
  # TODO maybe I don't want to use fish to manage my shell..?
 programs.fish.enable = true;
  programs.fish.shellInit = ''alias emacsc="emacsclient --create-frame --alternate-editor=\"\""
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias valserver="valgrind --vgdb=yes --vgdb-error=0"
alias weather="curl wttr.in"
alias vim="nvim"
alias ls="lsd"
set -a NIX_PATH $HOME/.nix-defexpr/channels
## Set environment
set TERM "xterm-256color"
export JANET_TREE=$HOME/.local/jpm_tree
#set EDITOR "micro"
export DOCKER_HOST="unix:///run/user/1000/docker.sock"
# fenv "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" # uncomment later when installing fish
# eval (direnv hook fish)
# starship init fish | source
fish_add_path -g ~/dotfiles/scripts
fish_add_path -g ~/.cargo/bin
fish_add_path -g ~/.local/bin/
'';
  programs.nushell = {
    enable = true;
    configFile.text = ''
    $env.config.show_banner = false
    '';
    };
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };
  

}
