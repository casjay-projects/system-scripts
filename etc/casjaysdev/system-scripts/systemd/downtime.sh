#!/bin/bash

if [ ! -d /var/lib/system-scripts/downtime ]; then
mkdir -p /var/lib/system-scripts/downtime
fi

#downtimed
DOWNTIME=$(date +"%T %Z")
DOWNDATE=$(date +"%A, %B %d, %Y")

echo "" > /etc/issue
echo "" > /etc/motd
echo "System shutdown on $DOWNDATE at $DOWNTIME"
echo "$DOWNDATE" > /var/lib/system-scripts/downtime/date.down
echo "$DOWNTIME" > /var/lib/system-scripts/downtime/time.down
/usr/share/system-scripts/downtime.sh > /dev/null
exit 0
