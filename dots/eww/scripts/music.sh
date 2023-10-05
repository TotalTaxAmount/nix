my_dir="$(dirname "$0")"
COVER=/tmp/cover.png

music() {
    TIME_LEFT=$($my_dir/music_utils.sh time)
    STATUS=$($my_dir/music_utils.sh status)
    PERCENT=$($my_dir/music_utils.sh percent)
    TITLE=$($my_dir/music_utils.sh title)

    if [ "$STATUS" != "Stopped" ]; then
        if (( $(echo "$PERCENT < 0.1" |bc -l) )); then
            $my_dir/music_utils.sh coverloc &> /dev/null
        fi
        create_output
    fi
    
}

create_output() {
    #Make an widget for eww
    echo "(box \
            :class \"music_container\"
            (label 
                :class \"music_title\"
                :tooltip \"$TITLE\"
                :limit-width 22
                :text \"$TITLE\"
                :wrap false
            )
            (image
                :class \"music_cover\"
                :path \"$COVER\"
                :image-width 75
                :image-height 75
            )
        )"
}

while true; do
    music
done

