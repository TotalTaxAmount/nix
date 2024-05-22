#!/run/current-system/sw/bin/bash

echo "I am running" >> /home/totaltaxamount/working.workpls

if [[ $1 == "win10" ]]; then
  if [[ $2 == "started" ]]; then
    systemctl set-property --runtime -- user.slice AllowedCPUs=0,1,8,9
    systemctl set-property --runtime -- system.slice AllowedCPUs=0,1,8,9
    systemctl set-property --runtime -- init.scope AllowedCPUs=0,1,8,9
    
  fi
  if [[ $2 == "stopped" ]]; then
    # Free all CPUs
    systemctl set-property --runtime -- user.slice AllowedCPUs=0-15
    systemctl set-property --runtime -- system.slice AllowedCPUs=0-15
    systemctl set-property --runtime -- init.scope AllowedCPUs=0-15
  fi
fi