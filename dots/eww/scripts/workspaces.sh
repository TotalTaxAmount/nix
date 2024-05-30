workspaces() {

	unset -v \
	o1 o2 o3 o4 o5 o6 o7 o8 o9 o10 \
	f1 f2 f3 f4 f5 f6 f7 f8 f9 f10

	ows="$(hyprctl workspaces -j | jq '.[] | del(select(.id == -99)) | .id')"

	for num in $ows; do
		export o"$num"="$num"
	done

	num="$(hyprctl monitors -j | jq '.[] | select(.id == 0).activeWorkspace.id')"
	export f"$num"="$num"

	echo	"(eventbox :onscroll \"echo {} | sed -e 's/up/-1/g' -e 's/down/+1/g' | xargs hyprctl dispatch workspace\" \
				(box	:class \"workspaces\"	:orientation \"h\" :space-evenly \"false\" 	\
					(button :onclick \"hyprctl dispatch workspace 1\" :class \"w0$o1$f1\" \"1\") \
					(button :onclick \"hyprctl dispatch workspace 2\" :class \"w0$o2$f2\" \"2\") \
					(button :onclick \"hyprctl dispatch workspace 3\" :class \"w0$o3$f3\" \"3\") \
					(button :onclick \"hyprctl dispatch workspace 4\" :class \"w0$o4$f4\" \"4\") \
					(button :onclick \"hyprctl dispatch workspace 5\" :class \"w0$o5$f5\" \"5\") \
					(button :onclick \"hyprctl dispatch workspace 6\" :class \"w0$o6$f6\" \"6\") \
					(button :onclick \"hyprctl dispatch workspace 7\" :class \"w0$o7$f7\" \"7\") \
					(button :onclick \"hyprctl dispatch workspace 8\" :class \"w0$o8$f8\" \"8\") \
					(button :onclick \"hyprctl dispatch workspace 9\" :class \"w0$o9$f9\" \"9\")))"
}

workspaces

socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r event; do 
workspaces "$event"
done
