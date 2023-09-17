export SWWW_TRANSITION_FPS=60
export SWWW_TRANSITION_STEP=2

# This controls (in seconds) when to switch to the next image
INTERVAL=60
swww init
while true; do
	find "/home/$USER/nix/dots/swww/wallpapers/" \
		| while read -r img; do
			echo "$((RANDOM % 1000)):$img"
		done \
		| sort -n | cut -d':' -f2- \
		| while read -r img; do
			swww img --transition-type center "$img"
			sleep $INTERVAL
		done
done
