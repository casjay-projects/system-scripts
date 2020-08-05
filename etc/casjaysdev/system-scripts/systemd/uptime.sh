#!/bin/bash

if [ ! -d /var/lib/system-scripts/uptime ]; then
mkdir -p /var/lib/system-scripts/uptime
fi

#UPTIMED
UPTIMEDTIME=$(date +"%T %Z")
UPTIMEDDATE=$(date +"%A, %B %d, %Y")

echo "" > /etc/issue
echo "" > /etc/motd
echo "System startup on $UPTIMEDDATE at $UPTIMEDTIME"
echo "$UPTIMEDDATE" > /var/lib/system-scripts/uptime/date.up
echo "$UPTIMEDTIME" > /var/lib/system-scripts/uptime/time.up
/usr/share/system-scripts/uptime.sh > /dev/null
/usr/share/system-scripts/issue.sh > /dev/null
rm -rf /var/lib/system-scripts/run/* > /dev/null
exit 0
