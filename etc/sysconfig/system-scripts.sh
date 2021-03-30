#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0")"
VERSION="202103292334-git"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202103292334-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : WTFPL
# @ReadME        : system-scripts.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Monday, Mar 29, 2021 23:34 EDT
# @File          : system-scripts.sh
# @Description   : Main source file for my server script
# @TODO          : Update code using template
# @Other         : This file will be over written on update!
# @Resource      : http://github.com/systemmgr/server
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ $# -ne 0 ]; then
  cat <<OEF
# Main source file for my servers
# This file will be over written on update!
# You may override any configuration in this file
# by creating /usr/share/system-scripts/include/*.sh
# and modifying that file or copy this file to
# /etc/casjaysdev/system-scripts/include/custom/customname.sh.
exit 1
OEF
fi

if [ ! -d /var/lib/system-scripts/log ]; then mkdir -p /var/lib/system-scripts/log; fi
if [ ! -d /var/lib/system-scripts/run ]; then mkdir -p /var/lib/system-scripts/run; fi
if [ ! -L /var/run/system-scripts ]; then ln -s /var/lib/system-scripts/run /var/run/system-scripts; fi
if [ ! -L /var/log/system-scripts ]; then ln -s /var/lib/system-scripts/log /var/log/system-scripts; fi

if [ ! -f /etc/casjaysdev/system-scripts/.firstrun ]; then
  echo "running the setup script in /etc/casjaysdev/system-scripts/setup.sh"
  source /etc/casjaysdev/system-scripts/setup.sh
  exit 10
fi

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin:/bin"
STARTDATE="$(/bin/date +"%m-%d-%Y")"
STARTTIME="$(/bin/date +"%r")"

HOST="$(hostname -f)"
HOSTNAME="$(hostname -f)"
HOSTSHORT="$(hostname -s)"

IFISONLINE="$(
  timeout 0.5 ping -c1 8.8.8.8 &>/dev/null
  echo $?
)"
IFISSERVER="$(
  hostname -f | grep -Eq "server"
  [ $? -eq 0 ] && echo "yes" || echo "no"
)"
IFISFTPSERVER="$(
  hostname -f | grep -Eq "ftp"
  [ $? -eq 0 ] && echo "yes" || echo "no"
)"
IFISBUILDSYS="$(
  hostname -f | grep -Eq "dev|build"
  [ $? -eq 0 ] && echo "yes" || echo "no"
)"
IFISMAILSERVER="$(
  hostname -f | grep -Eq "mail|smtp|pop"
  [ $? -eq 0 ] && echo "yes" || echo "no"
)"
IGNOREREMOTEDIRS="no"

DIST="$(rpm -q --whatprovides redhat-release --queryformat "%{VENDOR}\n" | sed 's/\/.*//' | sed 's/\..*//' | sed 's/Server*//' | sed 's#Project##' | cut -f 1 -d " " | sed 's/ //g')"
MIRRORDIST="$(echo $DIST | awk '{print tolower($0)}')"
ELRELEASE="$(rpm -q --whatprovides redhat-release --queryformat "%{VERSION}\n" | sed 's/\/.*//' | sed 's/\..*//' | sed 's/Server*//')"
ELARCH="$(uname -i)"
DISTARCH="$(uname -i)"

if [ "$DIST" = "Scientific" ] || [ "$DIST" = "RedHat" ] || [ "$DIST" = "CentOS" ] || [ "$DIST" = "Casjay" ]; then
  DIST=RHEL
fi

TODAY="$(/bin/date +%a)"
ONEDAYAGO="$(/bin/date --date="1 Days Ago" +%a)"
TWODAYSAGO="$(/bin/date --date="2 Days Ago" +%a)"
THREEDAYSAGO="$(/bin/date --date="3 Days Ago" +%a)"
FOURDAYSAGO="$(/bin/date --date="4 Days Ago" +%a)"
FIVEDAYSAGO="$(/bin/date --date="5 Days Ago" +%a)"
SIXDAYSAGO="$(/bin/date --date="6 Days Ago" +%a)"
SEVENDAYSAGO="$(/bin/date --date="7 Days Ago" +%a)"
SLEEPCMD="$(expr $RANDOM \% 3600)"

BASE="/usr/share/system-scripts"
BASEDIR="/var/lib/system-scripts"
CONFDIR="/etc/casjaysdev/system-scripts"
LOGDIR="/var/lib/system-scripts/log"
PIDDIR="/var/lib/system-scripts/run"
FTPDIR="/var/ftp"
FTPSUB="pub"
SYSLOGDIR="/var/log"
BACKUPDIR="/media/backups/Systems/$HOSTSHORT"
MIGRATEBASE="/usr/share/migrationtools"
LOGFILE="$LOGDIR/$PROG.log"
ERRORLOG="$LOGDIR/$PROG.err"
PIDFILE="$PIDDIR/$PROG.pid"
LOCKFILE="$PROG.lock"
ISOSDIR="$FTPDIR/$FTPSUB/isos"

WWWDIR="/var/www/html"
HTTPDCONF="/etc/httpd/conf"
HOSTEDDOMLIST="$WWWDIR/hosted-domains.txt"

BACKUPNAME="System-$TODAY.tar.gz"
BACKUPHOMENAME="Home-$TODAY.tar.gz"
ONEDAYBACKUPNAME="System-$ONEDAYAGO.tar.gz"
ONEDAYBACKUPHOMENAME="Home-$ONEDAYAGO.tar.gz"
TWODAYBACKUPNAME="System-$ONEDAYAGO.tar.gz"
TWOBACKUPHOMENAME="Home-$ONEDAYAGO.tar.gz"
EXCLUDEFILE="$BASEDIR/$PROG/exclude.txt"
INCLUDEFILE="$BASEDIR/$PROG/include.txt"
USERHOMEDIR="$(ls /home/)"
AWFFULLDIR="/etc/awffull"
AWSTATSDIR="/etc/awstats"
WEBALIZERDIR="/etc/webalizer"
MRTGDIR="/etc/mrtg"

SPACE="$(df -h | grep -Ev "tmp|udev|fuse|:|ISO|/mnt|/media" | awk '{print $5}' | grep % | grep -v Use | sort -n | tail -1 | cut -d "%" -f1 -)"
MAXDISK="60"
ALERTVALUE="$MAXDISK"

#For versions less than 7 change the awk '{print $2}' to awk '{print $3}' in CURRIP6
#Choose external network device you
#can find it by using ifconfig
#For Containers netdev might be venet
#NETDEVICE="venet0"
#LANDEVICE="venet0"
#For baremetal or virtual systems it is most likely eth0
#NETDEVICE="eth0"
#LANDEVICE="eth0"
MYHOSTS="$(/sbin/ifconfig | grep 'inet' | grep -v venet | grep -v inet6 | awk '{print $2}' | grep -Ev "127.0.0." | sed 's#addr:##g' | head -n1)"
CURRIP4="$(/sbin/ifconfig | grep -E "venet|inet" | grep -v "127.0.0." | grep 'inet' | grep -v inet6 | awk '{print $2}' | sed 's#addr:##g' | head -n1)"
CURRIP6="$(/sbin/ifconfig | grep -E "venet|inet" | grep 'inet6' | grep -i global | awk '{print $2}' | head -n1)"
#CURRIP4=""
#CURRIP6=""
MYIP4="$(cat $BASEDIR/checkip/myip4.txt)"
MYIP6="$(cat $BASEDIR/checkip/myip6.txt)"
#Change the SUM/1 to SUM/Number of network devices
UP="$(echo $(cat $LOGDIR/time.log | grep "%" | awk '{print $2}' | awk '{ SUM += $1} END { print SUM/1 }'))"

COWSAYFILE="$CONFDIR/messages/cowsay"
ISSUEFILE="$CONFDIR/messages/issue/default"
MOTDFILE="$CONFDIR/messages/motd/default"
LEGALFILE="$CONFDIR/messages/legal/default"
LEGALMESS="$CONFDIR/messages/legal/000.txt"
ISSUEMESS="$CONFDIR/messages/issue/000.txt"
MOTDMESS="$CONFDIR/messages/motd/000.txt"

#RSYNC
RSYNCEXCLUDEFILE="$BASEDIR/rsync/$ELARCH-exclude.txt"
BASEOSDIR="$FTPDIR/$FTPSUB/$DIST/$ELARCH/$ELRELEASE"
DLSRPMDIR="$FTPDIR/$FTPSUB/$DIST/SRPMS/$ELRELEASE"
BASECPANDIR="$FTPDIR/$FTPSUB/CPAN"
BASEPHPDIR="$FTPDIR/$FTPSUB/PHP"
TURNKEYLINUXDIR="$FTPDIR/$FTPSUB/TurnKeyLinux"
MYREPOBASE="$FTPDIR/$FTPSUB/Casjay/$DIST"

RSYNCCMD="rsync -avhPH --no-g --no-o --partial --omit-dir-times --delete --exclude-from=$RSYNCEXCLUDEFILE"

RSYNCFEDORA="no"
RSYNCCENTOS="no"
RSYNCEPEL="no"
RSYNCATRPM="no"
RSYNCNUX="no"
RSYNCREMI="no"
RSYNCFUSIONFREE="no"
RSYNCFUSIONNONFREE="no"
RSYNCCPAN="no"
RSYNCPHP="no"
RSYNTURNKEYLINUX="no"
RSYNCDEBIAN="no"
RSYNCUBUNTU="no"

#CENTOS RSYNC Options
CENTOSVER="7"
MIRRORCENTOS="rsync://mirrors.rit.edu/centos/$CENTOSVER/os/$ELARCH"
MIRRORCENTOSUPDATE="rsync://mirrors.rit.edu/centos/$CENTOSVER/updates/$ELARCH/Packages"
MIRRORCENTOSSRPMS="rsync://bay.uchicago.edu/centos-vault/centos/$CENTOSVER/os/Source/SPackages"
MIRRORCENTOSSRPMSUPDATES="rsync://bay.uchicago.edu/centos-vault/centos/$CENTOSVER/updates/Source/SPackages"
MIRROREPEL="rsync://mirrors.rit.edu/epel/$CENTOSVER/$ELARCH"
MIRROREPELDLSRPMS="rsync://bay.uchicago.edu/epel/$CENTOSVER/SRPMS/ $DLSRPMDIR/epel"

#NUX RSYNC Options
MIRRORNUX="rsync://ftp.pbone.net/pbone/mirror/li.nux.ro/download/nux/dextop/el$CENTOSVER/$ELARCH"
MIRRORNUXDLSRPMS="rsync://ftp.pbone.net/pbone/mirror/li.nux.ro/download/nux/dextop/el$CENTOSVER/SRPMS"

#REMI RSNYC Options
MIRRORREMI="rsync://mirrors.thzhost.com/remi/enterprise/$CENTOSVER/remi/$ELARCH"
MIRRORREMIDLSRPMS="rsync://fr2.rpmfind.net/linux/remi/SRPMS"

#RPMFUSION RSYNC Options
MIRRORFUSIONFREE="rsync://mirror.us.leaseweb.net/rpmfusion/nonfree/el/updates/$CENTOSVER/$ELARCH/"
MIRRORFUSIONNONFREE="rsync://mirror.us.leaseweb.net/rpmfusion/nonfree/el/updates/$CENTOSVER/$ELARCH/"
MIRRORFUSIONFREEDLSRPMS="rsync://mirror.us.leaseweb.net/rpmfusion/free/el/updates/$CENTOSVER/SRPMS"
MIRRORFUSIONNONFREESRPMS="rsync://mirror.us.leaseweb.net/rpmfusion/nonfree/el/updates/$CENTOSVER/SRPMS"

#CPAN RSYNC OPTIONS
MIRRORCPAN="rsync://mirrors.rit.edu/cpan"

#FEDORA RSYNC Options
FEDORAVER="32"
MIRRORFEDORA="rsync://mirrors.liquidweb.com/fedora/releases/$FEDORAVER/Everything/$ELARCH/os"
MIRRORFEDORAUPDATE="rsync://mirrors.liquidweb.com/fedora/updates/$FEDORAVER/$ELARCH"
MIRRORFEDORADLSRPMS="rsync://mirrors.liquidweb.com/fedora/updates/$FEDORAVER/SRPMS"
MIRRORFEDORADLSRPMSUPDATES="http://mirrors.liquidweb.com/fedora/releases/$FEDORAVER/Everything/source"

#DEBIAN RSYNC Options
DEBIANVER="10"
MIRRORDEBIAN="rsync://mirrors.liquidweb.com/debian"

#UBUNTU RSYNC Options
UNUNTUVER="20.04"
MIRRORUBUNTU="rsync://mirrors.liquidweb.com/ubuntu"

#PHP RSYNC Options
MIRRORPHP="rsync://mirror.cogentco.com/PHP"

#TURNKEYLINUX RSYNC Options
MIRRORTURNKEYLINUX="rsync://mirror.turnkeylinux.org:/turnkeylinux"
TURNKEYLINUXISOVER=images/iso/*-15*-*-amd64.iso
TURNKEYLINUXLXCVER=images/proxmox/*_15.*_amd64.tar.gz

DLSRPMS="no"
DLSRPMVER=$(rpm -q --whatprovides redhat-release --queryformat "%{VERSION}\n" | sed 's/\/.*//' | sed 's/\..*//' | sed 's/Server*//')

RPMPKGS="$WWWDIR/$DIST$ELRELEASE-$HOSTSHORT.txt"

#Lock files in case of shares
RSYNCLOCKDIR="$FTPDIR"

#BUILD System Config
RPMBUILDDIR="/home/builder/rpmbuild"
RPMS="$(ls $RPMBUILDDIR/RPMS/*/*.rpm 2>/dev/null | wc -l)"
SRPMS="$(ls $RPMBUILDDIR/SRPMS/*.rpm 2>/dev/null | wc -l)"
COMPSXMLFILE="/etc/casjaysdev/system-scripts/el7.x64-comps.xml"
COMPSXMLNAME="comps.xml"
CREATEREPOCMD="createrepo -d ./"

#Individual Program Names for sending notications
# -- Useful for debugging --
EMAILaliases="no"
EMAILawffull="no"
EMAILawstats="no"
EMAILbackuphome="no"
EMAILbackupsystem="no"
EMAILcheckip="no"
EMAILclean="no"
EMAILcreaterepo="no"
EMAILcron="no"
EMAILdomains="no"
EMAILdowntime="no"
EMAILhdspace="no"
EMAILhomesync="no"
EMAILhosts="no"
EMAILinitialize="no"
EMAILinstalledrpms="no"
EMAILissue="no"
EMAILmigrate="no"
EMAILmrtg="no"
EMAILotheroses="no"
EMAILprocesses="no"
EMAILrecords="no"
EMAILrpmpkgs="no"
EMAILrsync="no"
EMAILturnkeylinux="no"
EMAILuptime="no"
EMAILwebalizer="no"

#Enable Apps

#SystemMail Config
SENDMAIL="yes"
SENDMAILONERROR="yes"
MAILFROM="system-scripts@$HOST"
MAILRECIP="alerts@$HOST"
MAILSUB="System-Scripts: $PROG"
MAILHEADER="The $PROG script has been ran on $HOST"
MAILMESS1=""
MAILMESS2=""
MAILMESS3="Either no errors were reported or you have not enabled error reporting"
MAILFOOTER="Please check the $LOGFILE for more information"
STARTSUBJECT="$HOST - System Startup"
STOPSUBJECT="$HOST - System Shutdown"
STARTBODY="This is an automated message to notify you that $HOST started successfully on $(date +"%a %m/%d/%y") at $(date +"%H:%M")"
STOPBODY="This is an automated message to notify you that $HOST is shutting down on $(date +"%a %m/%d/%y") at $(date +"%H:%M")"

#Other sending configurations
SENDXMPP="no"
SENDTWIT="no"
SENDSMS="no"
XMPP="sendxmpp all@broadcast.your.server -f /root/.sendxmpprc"
EMAIL="root@$HOST"
TWEETYSENDER="root@$HOST"
TWITTER="tweet@tweetymail.com"
GVOICE="gvoice send_sms yournumber"

#Uptime and Downtime
UPDATE="$(cat $BASEDIR/uptime/date.up)"
UPTIME="$(cat $BASEDIR/uptime/time.up)"
DOWNDATE="$(cat $BASEDIR/downtime/date.down)"
DOWNTIME="$(cat $BASEDIR/downtime/time.down)"
UP="$(echo $(cat /var/lib/system-scripts/log/time.log | grep "%" | awk '{print $2}' | awk '{ SUM += $1} END { print SUM/1 }'))"

#LDAP Config
CNUSER="manager"
CNPASS="yourpassword"
DC1="your"
DC2="tld"

INCLUDESCRIPTS=$(ls $CONFDIR/include/main/*.sh 2>/dev/null | wc -l)
if [ "$INCLUDESCRIPTS" != "0" ]; then
  for file in "$CONFDIR/include/main"/*.sh; do
    source "$file"
  done
fi

INCLUDESCRIPTSCUSTOM=$(ls $CONFDIR/include/custom/*.sh 2>/dev/null | wc -l)
if [ "$INCLUDESCRIPTSCUSTOM" != "0" ]; then
  for file in "$CONFDIR/include/custom"/*.sh; do
    source "$file"
  done
fi

