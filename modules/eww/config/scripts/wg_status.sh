if systemctl is-active --quiet wg-quick-wg0.service; then
    echo "🔒"
else
    echo "🔓"
fi
