{ config, lib, pkgs, ... }:

{
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
#set EDITOR "micro"
export DOCKER_HOST="unix:///run/user/1000/docker.sock"
# fenv "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" # uncomment later when installing fish
# eval (direnv hook fish)
# starship init fish | source
fish_add_path -g ~/dotfiles/scripts
fish_add_path -g ~/.cargo/bin
'';
}
