{ config, lib, pkgs, ... }:

{
  # TODO maybe I don't want to use fish to manage my shell..?
  programs.fish.enable = true;
  programs.fish.shellInit = ''
    alias emacsc="emacsclient --create-frame --alternate-editor=\"\""
    alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
    alias valserver="valgrind --vgdb=yes --vgdb-error=0"
    alias weather="curl wttr.in"
    alias vim="nvim"
    alias ls="lsd"
    alias cat="bat"
    set -a NIX_PATH $HOME/.nix-defexpr/channels
    ## Set environment
    set TERM "xterm-256color"
    export JANET_TREE=$HOME/.local/jpm_tree
    set EDITOR "nvim"
    export DOCKER_HOST="unix:///run/user/1000/docker.sock"
    # fenv "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" # uncomment later when installing fish
    # eval (direnv hook fish)
    # starship init fish | source
    fish_add_path -g ~/dotfiles/scripts
    fish_add_path -g ~/.cargo/bin
    fish_add_path -g ~/.local/bin/
    source ${pkgs.pass}/share/fish/vendor_completions.d/pass.fish
  '';
  programs.nushell = {
    enable = true;
    package =
      (pkgs.nushell.override { additionalFeatures = (p: p ++ [ "extra" ]); });
    configFile.text = ''
      let carapace_completer = {|spans|
      carapace $spans.0 nushell $spans | from json
      }
      $env.config = {
       show_banner: false,
       completions: {
       case_sensitive: false # case-sensitive completions
       quick: true    # set to false to prevent auto-selecting completions
       partial: true    # set to false to prevent partial filling of the prompt
       algorithm: "fuzzy"    # prefix or fuzzy
       external: {
       # set to false to prevent nushell looking into $env.PATH to find more suggestions
           enable: true 
       # set to lower can improve completion performance at the cost of omitting some options
           max_results: 100 
           completer: $carapace_completer # check 'carapace_completer' 
         }
       }
      } 
      $env.PATH = ($env.PATH | 
      split row (char esep) |
      prepend /home/myuser/.apps |
      append /usr/bin/env
      )
    '';
  };
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;

    # TODO: make config for this later
  };
  programs.carapace.enable = true;
  programs.carapace.enableNushellIntegration = true;

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
  };

}
