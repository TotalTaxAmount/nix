battery() {
    BAT=$(ls /sys/class/power_supply | grep BAT | head -n 1)
    cat /sys/class/power_supply/${BAT}/capacity
}

battery_stat() {
    BAT=$(ls /sys/class/power_supply | grep BAT | head -n 1)
    cat /sys/class/power_supply/${BAT}/status
}

battery_icon() {
    BAT=$(ls /sys/class/power_supply | grep BAT | head -n 1)
    CAPACITY=$(cat /sys/class/power_supply/${BAT}/capacity)
    STATUS=$(cat /sys/class/power_supply/${BAT}/status)

    if [[ "$STATUS" == "Charging" ]]; then
        echo "󰂄"
    else
        if [[ $CAPACITY -ge 100 ]]; then
            echo "󰁹"
        elif [[ $CAPACITY -ge 90 ]]; then
            echo "󰂂"
        elif [[ $CAPACITY -ge 80 ]]; then
            echo "󰂁"
        elif [[ $CAPACITY -ge 70 ]]; then
            echo "󰂀"
        elif [[ $CAPACITY -ge 60 ]]; then
            echo "󰁿"
        elif [[ $CAPACITY -ge 50 ]]; then
            echo "󰁾"
        elif [[ $CAPACITY -ge 40 ]]; then
            echo "󰁽"
        elif [[ $CAPACITY -ge 30 ]]; then
            echo "󰁼"
        elif [[ $CAPACITY -ge 20 ]]; then
            echo "󰁻"
        elif [[ $CAPACITY -ge 10 ]]; then
            echo "󰁺"
        else
            echo "󰁺"
        fi
    fi
}

if [[ "$1" == "charge" ]]; then
    battery
elif [[ "$1" == "status" ]]; then
    battery_stat
elif [[ "$1" == "icon" ]]; then
    battery_icon
fi

