LOCKDIR=/tmp/vpnlock

enable() {
    alacritty -T VPN_ -e systemctl start wg-quick-wg0.service | echo
}

disable() {
    alacritty -T VPN_ -e systemctl stop wg-quick-wg0.service | echo
}

cleanup() {
    if rmdir -- "$LOCKDIR"; then
        echo "Finished"
    else
        echo >&2 "Failed to remove lock directory '$LOCKDIR'"
        exit 1
    fi
}

if mkdir -- "$LOCKDIR"; then
    #Ensure that if we "grabbed a lock", we release it
    #Works for SIGTERM and SIGINT(Ctrl-C) as well in some shells
    #including bash.
    trap "cleanup" EXIT
    if [ "$1" = "--enable" ]; then
        enable
    else
        disable
    fi
else
    echo >&2 "Could not create lock directory '$LOCKDIR'"
    exit 1
fi