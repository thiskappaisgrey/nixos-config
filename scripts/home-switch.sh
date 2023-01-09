#!/bin/sh
# TODO based on the hostname - use the right command
dotPath="/home/thanawat/.dotfiles"
if [[ $(hostname) == "thanawat-um560" ]]; then
    echo "on um560";
    home-manager switch --flake "${dotPath}#desktop";
else
    echo "not on um560";
    home-manager switch --flake "${dotPath}#laptop";
fi


