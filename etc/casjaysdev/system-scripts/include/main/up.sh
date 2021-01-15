UP="$(echo $(cat /var/lib/system-scripts/log/time.log | grep "%" | awk '{print $2}' | awk '{ SUM += $1} END { print SUM/1 }'))"
