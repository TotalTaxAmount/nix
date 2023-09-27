# TODO: Make this better
DIR="/home/$USER/nix/shells"

echo "Enabling $1"
nix-shell $DIR/$1 --run "zsh"