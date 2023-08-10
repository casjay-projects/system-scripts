#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0")"
VERSION="202103292345-git"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202103292345-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.pro
# @License       : WTFPL
# @ReadME        : uptime.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Monday, Mar 29, 2021 23:45 EDT
# @File          : uptime.sh
# @Description   : Creates an uptime file at boot
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ ! -d /var/lib/system-scripts/uptime ]; then
  mkdir -p /var/lib/system-scripts/uptime
fi

#UPTIMED
UPTIMEDTIME=$(date +"%T %Z")
UPTIMEDDATE=$(date +"%A, %B %d, %Y")

echo "" >/etc/issue
echo "" >/etc/motd
echo "System startup on $UPTIMEDDATE at $UPTIMEDTIME"
echo "$UPTIMEDDATE" >/var/lib/system-scripts/uptime/date.up
echo "$UPTIMEDTIME" >/var/lib/system-scripts/uptime/time.up
/usr/share/system-scripts/uptime.sh >/dev/null
/usr/share/system-scripts/issue.sh >/dev/null
rm -rf /var/lib/system-scripts/run/* >/dev/null
exit 0
