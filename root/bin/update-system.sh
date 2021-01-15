#!/bin/sh

IFISONLINE="$(
  ping -c1 8.8.8.8 &>/dev/null
  echo $?
)"

if [ "$IFISONLINE" -ne "0" ]; then
  exit 1
fi

INCLUDEUPDATES=$(ls /etc/casjaysdev/updates/include/*.sh 2>/dev/null | wc -l)
if [ "$INCLUDEUPDATES" != "0" ]; then
  for file in /etc/casjaysdev/updates/include/*.sh; do
    source "$file"
  done
fi
/root/bin/changeip.sh
