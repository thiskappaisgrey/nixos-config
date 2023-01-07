#!/bin/sh
dotPath="/home/thanawat/.dotfiles"
if [[ $(hostname) == "thanawat-um560" ]]; then
    echo "on um560";
    sudo nixos-rebuild switch --flake "${dotPath}#um560"
else
    echo "not on um560";
    sudo nixos-rebuild switch --flake "${dotPath}#thinkpad-t480"
fi

