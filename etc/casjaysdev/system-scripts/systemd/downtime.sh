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
# @ReadME        : downtime.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Monday, Mar 29, 2021 23:45 EDT
# @File          : downtime.sh
# @Description   : Creates a file recording shutdown time
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


if [ ! -d /var/lib/system-scripts/downtime ]; then
  mkdir -p /var/lib/system-scripts/downtime
fi

#downtimed
DOWNTIME=$(date +"%T %Z")
DOWNDATE=$(date +"%A, %B %d, %Y")

echo "" >/etc/issue
echo "" >/etc/motd
echo "System shutdown on $DOWNDATE at $DOWNTIME"
echo "$DOWNDATE" >/var/lib/system-scripts/downtime/date.down
echo "$DOWNTIME" >/var/lib/system-scripts/downtime/time.down
/usr/share/system-scripts/downtime.sh >/dev/null
exit 0
