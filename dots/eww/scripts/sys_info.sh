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
get_mem() {
	printf "%.0f\n" $(free -m | grep Mem | awk '{print ($3/$2)*100}')
}

get_bright() {
	echo `brightnessctl | awk 'NR==2 {gsub(/[^0-9]/, "", $4); print $4}'`
}

get_net_adp() {
	echo `ip addr | awk '/state UP/ {print $2}' | tr -d :`
}

get_disk () {
	echo `df -h 2>/dev/null | awk '/\/nix/{print $4}' | sed 's/%//'`
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
fi
