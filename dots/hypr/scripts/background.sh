export SWWW_TRANSITION_FPS=60
export SWWW_TRANSITION_STEP=2

INTERVAL=60
swww-daemon
while true; do
	find "/home/$USER/nix/dots/swww/wallpapers/" \
		| while read -r img; do
			echo "$((RANDOM % 1000)):$img"
		done \
		| sort -n | cut -d':' -f2- \
		| while read -r img; do
      dunstify "Background Changed" "New background: $img"
			swww img --transition-type=center "$img"
			sleep $INTERVAL
		done
done
