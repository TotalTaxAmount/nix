#! /usr/bin/env bash

# It has to be up here
set_host() {
    read -p "Are you sure you want to set your host to $1? (y/n) : " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]];then
        echo $1 > HOST
        echo "Done" 
    else
        exit 0
    fi
}

USER=$(whoami)
if [ ! -e /home/$USER/nix/HOST ];then
    echo "No host defined"
    read -p "Enter the name of your host (defined in /outputs/nixos.nix) : " name
    set_host $name
fi
HOST=$(cat /home/$USER/nix/HOST)

echo "Current host: $HOST"

nix_build() {
    case $2 in
        "offline")
            echo "Building offline"
            nix build $1 --option substitute false;;
        *)
        nix build $1;;
    esac
}

package_update() {
    sudo nixos-rebuild switch --flake .#$HOST --upgrade
}

rebuild_home() {
    nix_build ".#homeConfigurations.$HOST.activation-script" $1
    if [ $? -eq 0 ]; then
        HOME_MANAGER_BACKUP=bak result/activate
        result/activate
    else
        echo "Error building home config"
    fi
}

rebuild_system() {
    sudo nixos-rebuild switch --flake .#$HOST
}

install_fresh() {
    echo "Are you sure you are ready"
    read -p "If so hit y: " -n 1 -r
    echo   
    if [[ $REPLY =~ ^[Yy]$ ]];then
        echo "Copying system scan"
        cp -r /etc/nixos/hardware-configuration.nix ./hosts/$HOST/hardware.nix
        echo "Building..."
        sudo nixos-rebuild switch --flake .#$HOST
        rebuild_home
        echo "Done"
    fi
    
}


case $1 in
    "home")
        (cd /home/$USER/nix && rebuild_home $2);;
    "system")
        (cd /home/$USER/nix && rebuild_system $2);;
    "fresh")
        (cd /home/$USER/nix && install_fresh);;
    "packages")
        (cd /home/$USER/nix && package_update);;
    "set")
        (cd /home/$USER/nix && set_host $2);;
    *)
    echo "Options are home, system, set, packages and fresh"
esac
