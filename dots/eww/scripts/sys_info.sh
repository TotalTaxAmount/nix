PREV_TOTAL=0
PREV_IDLE=0
CPU_FILE="/tmp/.cpu_usage"

get_cpu() {
	if [[ -f "${CPU_FILE}" ]]; then
		fileCont=$(cat "${CPU_FILE}")
		PREV_TOTAL=$(echo "${fileCont}" | head -n 1)
		PREV_IDLE=$(echo "${fileCont}" | tail -n 1)
	else
		touch "${CPU_FILE}"
	fi

	CPU=(`cat /proc/stat | grep '^cpu '`) # Get the total CPU statistics.
	unset CPU[0]                          # Discard the "cpu" prefix.
	IDLE=${CPU[4]}                        # Get the idle CPU time.

	# Calculate the total CPU time.
	TOTAL=0

	for VALUE in "${CPU[@]:0:4}"; do
		let "TOTAL=$TOTAL+$VALUE"
	done

	if [[ "${PREV_TOTAL}" != "" ]] && [[ "${PREV_IDLE}" != "" ]]; then
		# Calculate the CPU usage since we last checked.
		let "DIFF_IDLE=$IDLE-$PREV_IDLE"
		let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
		let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
		echo "${DIFF_USAGE}"
	else
		echo "?"
	fi

	# Remember the total and idle CPU times for the next check.
	echo "${TOTAL}" > "${CPU_FILE}"
	echo "${IDLE}" >> "${CPU_FILE}"
}

get_temp() {
  TEMP_FILE="/sys/class/thermal/thermal_zone0/temp"
  if [ ! -f "$TEMP_FILE" ]; then
      echo "Temperature file not found. Ensure you're running on a compatible system."
      exit 1
  fi

  TEMP=$(cat $TEMP_FILE)
  TEMP_C=$(echo "scale=1; $TEMP / 1000" | bc)
  TEMP_F=$(echo "scale=1; ($TEMP_C * 9/5) + 32" | bc)

  echo $TEMP_F
}

get_mem() {
	printf "%.0f\n" $(free -m | grep Mem | awk '{print ($3/$2)*100}')
}

get_bright() {
	echo `brightnessctl | awk 'NR==2 {gsub(/[^0-9]/, "", $4); print $4}'`
}

get_volume() {
  volume=$(amixer get Master | grep -oP '\[\d{1,3}%\]' | head -1 | tr -d '[]%')
  echo $volume
}

get_net_adp() {
	echo `ip addr | awk '/state UP/ {print $2}' | tr -d :`
}

get_disk () {
	echo `df -h 2>/dev/null | grep ' /$' | awk '{print $5}'` | sed 's/%//'
}

get_up() {
  uptime_seconds=$(cat /proc/uptime | awk '{print int($1)}')

  hours=$((uptime_seconds / 3600))
  minutes=$(((uptime_seconds % 3600) / 60))
  seconds=$((uptime_seconds % 60))

  printf "%02d:%02d:%02d\n" $hours $minutes $seconds
}

get_net () { # TODO: Make this accurate!
    local interface=$(get_net_adp)
    local prev_bytes
    local curr_bytes

    if [ "$1" = "--up" ]; then
        prev_bytes=$(cat "/sys/class/net/$interface/statistics/tx_bytes")
        sleep 1  # Wait for 1 second
        curr_bytes=$(cat "/sys/class/net/$interface/statistics/tx_bytes")
    else
        prev_bytes=$(cat "/sys/class/net/$interface/statistics/rx_bytes")
        sleep 1  # Wait for 1 second
        curr_bytes=$(cat "/sys/class/net/$interface/statistics/rx_bytes")
    fi

    local bytes_transferred=$((curr_bytes - prev_bytes))
    local mbps=$(echo "scale=2; $bytes_transferred / 125000" | bc)
    echo "$mbps Mb/s"
}

if [[ "$1" == "--cpu" ]]; then
	get_cpu
elif [[ "$1" == "--mem" ]]; then
	get_mem
elif [[ "$1" == "--bright" ]]; then
	get_bright
elif [[ "$1" == "--disk" ]]; then
	get_disk
elif [[ "$1" == "--adp" ]]; then
	get_net_adp
elif [[ "$1" == "--netup" ]]; then
	get_net --up
elif [[ "$1" == "--netdown" ]]; then
	get_net
elif [[ "$1" == "--up" ]]; then
  get_up
elif [[ "$1" == "--temp" ]]; then
  get_temp
elif [[ "$1" == "--vol" ]]; then
  get_volume
fi
