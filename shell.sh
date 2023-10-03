#!/usr/bin/env bash
DIR="/home/$USER/nix/shells"

start_shell() {
    if [ -z $1 ]; then
        echo "Error: No shell specified!"
        echo
        list_shells
        exit 1
    fi
    echo "Enabling $1"
    if [ "$2" = "--unfree" ]; then
        echo "Enableing unfree pkgs"
        export NIXPKGS_ALLOW_UNFREE=1 
        nix-shell $DIR/$1 --run "zsh" 
    else
        nix-shell $DIR/$1 --run "zsh" 
    fi
}

list_shells() {
    echo "Avalible shells:"
    for entry in "$DIR"/*;
    do
        echo "$(basename $entry)"
    done
}

case $1 in
    "ls")
        (list_shells);;
    "s")
        (start_shell $2 $3);;
    *)
    echo "Options are ls and s (start)"
esac
