#!/usr/bin/env bash
temp=$(pcsensor -fm | awk 'NR > 1 { exit }; 1' | awk '{printf "%.0f\n", $1}')
if [ $temp -gt 100 ]; then

  echo -e "Count is cabinent tempature is than 100 degrees\nIt is currently at $temp" | mail -s "Cabinent Tempature Alert" -r admin@$HOSTNAME alerts@$HOSTNAME
fi
