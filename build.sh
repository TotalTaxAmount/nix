#! /usr/bin/env bash
set +x


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
    HOME_MANAGER_BACKUP=bak result/activate
    result/activate
}

rebuild_system() {
    sudo nixos-rebuild switch --flake .#laptop
}


case $1 in
    "home")
        rebuild_home $2;;
    "system")
        rebuild_system $2;;
    *)
    echo "Options are home or system"
esac