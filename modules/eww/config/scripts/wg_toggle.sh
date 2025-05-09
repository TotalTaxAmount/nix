get_password() {
    PINENTRY_OUTPUT=$(echo "getpin" | pinentry)
    PASSWORD=$(echo "$PINENTRY_OUTPUT" | awk -F' ' '/D/ {print $2}')
    echo $PASSWORD
}

PASSWORD=$(get_password)

if systemctl is-active --quiet wg-quick-wg0.service; then
    echo "$PASSWORD" | sudo -S systemctl stop wg-quick-wg0.service
    echo "🔓"
else
    echo "$PASSWORD" | sudo -S systemctl start wg-quick-wg0.service
    echo "🔒"
fi
