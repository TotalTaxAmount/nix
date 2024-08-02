EWW_BIN=$(which eww)
WIDGET="$1"

if ${EWW_BIN} active-windows | grep $WIDGET$ ; then
        ${EWW_BIN} close "$WIDGET"
else ${EWW_BIN} open "$WIDGET"
fi
