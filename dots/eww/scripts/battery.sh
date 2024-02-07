battery() {
	BAT=`ls /sys/class/power_supply | grep BAT | head -n 1`
	cat /sys/class/power_supply/${BAT}/capacity
}
battery_stat() {
	BAT=`ls /sys/class/power_supply | grep BAT | head -n 1`
	cat /sys/class/power_supply/${BAT}/status
}

if [[ "$1" == "charge" ]]; then
	battery
elif [[ "$1" == "status" ]]; then
	battery_stat
fi

