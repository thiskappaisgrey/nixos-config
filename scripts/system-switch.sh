#!/bin/sh
dotPath="/home/thanawat/.dotfiles"
sudo nixos-rebuild switch --flake "${dotPath}#thinkpad-t480"
