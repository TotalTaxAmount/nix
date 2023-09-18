#! /usr/bin/env bash

USER=$(whoami)
nix_build() {
    case $2 in
        "offline")
            echo "Building offline"
            nix build $1 --option substitute false;;
        *)
        nix build $1;;
    esac
}

rebuild_home() {
    nix_build ".#homeConfigurations.totaltax.activation-script" $1
    if [ $? -eq 0 ]; then
        HOME_MANAGER_BACKUP=bak result/activate
        result/activate
    else
        echo "Error building home config"
    fi
}

rebuild_system() {
    sudo nixos-rebuild switch --flake .#laptop
}

install_fresh() {
    read -p "Are you sure? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]];then
        sudo nixos-rebuild switch --experimental-features 'nix-command flakes' --flake .#laptop
        rebuild_home
    fi
    
}


case $1 in
    "home")
        (cd /home/$USER/nix && rebuild_home $2);;
    "system")
        (cd /home/$USER/nix && rebuild_system $2);;
    "fresh")
        (cd /home/$USER/nix && install_fresh);;
    *)
    echo "Options are home, system and fresh"
esac