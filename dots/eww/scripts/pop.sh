EWW_BIN=$(which eww)


WIDGET="$1"

popable_widgets=( "calendar" "system" )

# Open widgets
if ${EWW_BIN} windows | grep ^$WIDGET$ ; then
    for name in "${popable_widgets[@]}"
    do
        ${EWW_BIN} close "${name}"
    done
    ${EWW_BIN} open "$WIDGET"

elif ${EWW_BIN} windows | grep ^\*$WIDGET$ ; then
    ${EWW_BIN} close "$WIDGET"
else exit
fi
