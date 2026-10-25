#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="${NIXOS_CONFIG_DIR:-$HOME/nix}"
HOST_FILE="$REPO_ROOT/HOST"
NIXOS_HOST="${NIXOS_HOST:-}"

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage: update <command>

Commands:
  home        Rebuild and activate the Home Manager configuration
  system      Rebuild and switch the NixOS configuration
  fresh       Copy the current hardware configuration and rebuild
  set <host>  Set the host name stored in the repo's HOST file
  flake       Update the flake inputs
EOF
}

require_repo() {
  [[ -f "$REPO_ROOT/flake.nix" ]] || die "no flake found at $REPO_ROOT (set NIXOS_CONFIG_DIR)"
}

require_host() {
  if [[ -z "$NIXOS_HOST" && -f "$HOST_FILE" ]]; then
    NIXOS_HOST="$(<"$HOST_FILE")"
  fi
  [[ -n "$NIXOS_HOST" ]] || die "no host set; run: update set <host>"
}

sudo_cmd() {
  local sudo_bin
  sudo_bin="$(command -v sudo)" || die "sudo not found"
  "$sudo_bin" "$@"
}

SUDO_KEEPALIVE_PID=""

prime_sudo() {
  sudo_cmd -v
  (
    while sleep 60; do
      sudo_cmd -n -v >/dev/null 2>&1 || exit 0
    done
  ) &
  SUDO_KEEPALIVE_PID=$!
}

stop_sudo_keepalive() {
  if [[ -n "$SUDO_KEEPALIVE_PID" ]]; then
    kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
    wait "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
    SUDO_KEEPALIVE_PID=""
  fi
}

trap stop_sudo_keepalive EXIT

nixos_rebuild() {
  local rebuild_bin
  rebuild_bin="$(command -v nixos-rebuild)" || die "nixos-rebuild not found"
  sudo_cmd "$rebuild_bin" "$@"
}

set_host() {
  local host="${1:-}"
  if [[ -z "$host" ]]; then
    [[ -t 0 ]] || die "usage: update set <host>"
    read -rp "Enter host name: " host
  fi
  [[ -n "$host" ]] || die "host name cannot be empty"
  printf '%s\n' "$host" >"$HOST_FILE"
  echo "Host set to $host"
}

rebuild_system() {
  require_host
  prime_sudo
  if command -v nom >/dev/null 2>&1; then
    nom build --no-link "$REPO_ROOT#nixosConfigurations.$NIXOS_HOST.config.system.build.toplevel"
  fi
  nixos_rebuild switch --flake "$REPO_ROOT#$NIXOS_HOST"
}

rebuild_home() {
  require_host
  local out="$REPO_ROOT/result"
  (
    cd "$REPO_ROOT"
    if command -v nom >/dev/null 2>&1; then
      nom build "$REPO_ROOT#homeConfigurations.$NIXOS_HOST.activation-script"
    else
      nix build "$REPO_ROOT#homeConfigurations.$NIXOS_HOST.activation-script"
    fi
  )
  "$out/activate"
}

install_fresh() {
  # TODO: fix the fresh flow later
  echo "Are you sure?"
  read -rp "[y/N]: " -n 1 reply
  echo
  if [[ "$reply" =~ ^[Yy]$ ]]; then
    cp -r /etc/nixos/hardware-configuration.nix "$REPO_ROOT/hosts/$NIXOS_HOST/hardware.nix"
    echo "Building system..."
    nixos_rebuild switch --experimental-features 'nix-command flakes' --flake "$REPO_ROOT#$NIXOS_HOST"
    echo "Building home..."
    rebuild_home
    echo "Done"
  fi
}

update_flake() {
  (cd "$REPO_ROOT" && nix flake update)
}

require_repo

command="${1:-}"
case "$command" in
  home)
    rebuild_home
    ;;
  system)
    rebuild_system
    ;;
  fresh)
    require_host
    install_fresh
    ;;
  set)
    shift
    set_host "${1:-}"
    ;;
  flake)
    update_flake
    ;;
  "" | help | -h | --help)
    usage
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac
