SHELLS_DIR="/home/totaltaxamount/Shells"

if [ $# -ne 1 ]; then
  echo "Usage: shell <shell_name>"
  exit 1
fi

shell_name="$1"

if [ ! -f "$SHELLS_DIR/$shell_name.nix" ]; then
  echo "Error: Shell configuration '$shell_name.nix' not found."
  exit 1
fi

if ! nix-shell "$SHELLS_DIR/$shell_name.nix" --run zsh; then
  echo "Error: Failed to start the shell."
  exit 1
fi


