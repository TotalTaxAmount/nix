workspaces() {
	title=$(hyprctl activewindow -j | jq -r '.title')
	if [ "$title" == "null" ]; then
		title=""
	fi
}

module() {
#output eww widget
	echo 	"(box \
                :orientation \"h\" \
                :space-evenly false \
                :valign \"fill\" \
                :vexpand true \
                (label \
                    :class \"appname\" \
                    :limit-width \"35\" \
                    :text \"$title\" \
                    :tooltip \"$title\"))"
}

socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r event; do 
workspaces "$event"
module
done
