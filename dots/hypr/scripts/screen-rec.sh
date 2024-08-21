# If wl-screenrec is already running, stop recording.
if pgrep -x "wl-screenrec" > /dev/null; then
    killall -s 2 wl-screenrec
    exit 0
fi

FILE="$XDG_SCREENREC_DIR/$(date +'screencast_%Y%m%d%H%M%S.mp4')"
wl-screenrec -g "$(slurp && dunstify "Starting screencast" --timeout=1000)" --filename $FILE &&
ffmpeg -i $FILE -ss 00:00:00 -vframes 1 /tmp/screenrec_thumbnail.png -y &&
printf -v out "`dunstify "Recording saved to $FILE" \
    --icon "/tmp/screenrec_thumbnail.png" \
    --action="default,Open"`"

