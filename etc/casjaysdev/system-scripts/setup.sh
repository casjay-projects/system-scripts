#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0")"
VERSION="202103292355-git"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts
PROG=setup
PROGPID=$(echo $$)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202103292355-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.pro
# @License       : WTFPL
# @ReadME        : setup.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Monday, Mar 29, 2021 23:55 EDT
# @File          : setup.sh
# @Description   : Primary install script
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ $# -gt 0 ]; then
  cat <<EOF
Supports the following variables
MY_STATE
MY_CITY
MY_COMPANY
MY_UNIT
MY_DOMAIN
MY_ADMIN_EMAIL

EOF

if [ $UID != 0 ] || [ "$USER" != "root" ]; then
  echo "this script requires root/sudo"
  echo "Rerun with sudo or su -c "
fi

FQDN="${MY_DOMAIN:-$(hostname -f)}"
if [ "${FQDN}" = "" ]; then
  echo "This need a full hostname"
  exit 1
fi

${MY_STATE:-MyState}
${MY_CITY:-MyCity}
${MY_COMPANY:-SomeCompany}
${MY_UNIT:-SomeUnit}
${MY_DOMAIN:-$FQDN}
${MY_ADMIN_EMAIL:-root@FQDN}

fi
if [ -f /etc/casjaysdev/system-scripts/.firstrun ]; then
  echo "This seems to have already been ran"
  echo "This should not be called directly"
  exit 0
fi

mkdir -p /var/lib/system-scripts/checkip /etc/casjaysdev

if [ ! -d /var/lib/system-scripts/log ]; then
  mkdir -p /var/lib/system-scripts/log
fi
if [ ! -d /var/lib/system-scripts/run ]; then
  mkdir -p /var/lib/system-scripts/run
fi
if [ ! -d /var/run/system-scripts ] && [ ! -L /var/run/system-scripts ]; then
  ln -s /var/lib/system-scripts/run /var/run/system-scripts
fi
if [ ! -d /var/log/system-scripts ] && [ ! -L /var/log/system-scripts ]; then
  ln -s /var/lib/system-scripts/log /var/log/system-scripts
fi

ELARCH=$(uname -i)
ELRELEASE=$(rpm -q --whatprovides redhat-release --queryformat "%{VERSION}\n" | sed 's/\/.*//' | sed 's/\..*//' | sed 's/Server*//')
DIST=$(rpm -q --whatprovides redhat-release --queryformat "%{VENDOR}\n" | sed 's/\/.*//' | sed 's/\..*//' | sed 's/Server*//' | sed 's#Project##' | sed "s/ //g")
if [ $DIST = "Scientific" ] || [ $DIST = "RedHat" ] || [ $DIST = "CentOS" ] || [ $DIST = "Casjay" ]; then
  DIST=RHEL
fi

echo "Distribution is $DIST"
if [ $DIST = "RHEL" ]; then
  yum install -y ftp://ftp.casjay.pro/pub/Casjay/RHEL/$ELARCH/$ELRELEASE/rpms/casjay-release-1.0-1.casjay.el$ELRELEASE.x86_64.rpm
fi

if [ $DIST = "Fedora" ]; then
  yum install -y ftp://ftp.casjay.pro/pub/Casjay/Fedora/$ELARCH/$ELRELEASE/rpms/casjay-release-1-1.1.casjay.fc$ELRELEASE.x86_64.rpm
fi

echo "Setting up and installing dependencies"
rpm -e --nodeps cronie-anacron && rm -Rf /etc/cron*/0*
yum update -y
yum install -y proftpd createrepo cronie-noanacron munin-node bind vim bash-completion --skip-broken
yum install -y rsync rsync-daemon uptimed downtimed awstats awffull webalizer cowsay fortune-mod ponysay --skip-broken
yum install -y fail2ban shorewall shorewall6 bc netdata postfix proftpd httpd net-snmp php-fpm uptimed downtimed net-tools mailx --skip-broken

/usr/bin/openssl genrsa -rand /proc/apm:/proc/cpuinfo:/proc/dma:/proc/filesystems:/proc/interrupts:/proc/ioports:/proc/pci:/proc/rtc:/proc/uptime 2048 >/etc/pki/tls/private/localhost.key 2>/dev/null

cat <<EOF | /usr/bin/openssl req -new -key /etc/pki/tls/private/localhost.key \
  -x509 -sha256 -days 365 -set_serial $RANDOM -extensions v3_req \
  -out /etc/pki/tls/certs/localhost.crt 2>/dev/null
--
${MY_STATE:-SomeState}
${MY_CITY:-SomeCity}
${MY_COMPANY:-SomeOrganization}
${MY_UNIT:-SomeOrganizationalUnit}
${MY_DOMAIN:-$FQDN}
${MY_ADMIN_EMAIL:-root@$FQDN}
EOF

MYIP4="$(/sbin/ifconfig | grep -E "venet|inet" | grep -v "127.0.0." | grep 'inet' | grep -v inet6 | awk '{print $2}' | sed 's#addr:##g' | head -n1)"
MYIP6=$(/sbin/ifconfig | grep -E "venet|inet" | grep 'inet6' | grep -i global | awk '{print $2}' | head -n1)
VHOSTS=$(ls /etc/httpd/conf/vhosts.d/*.conf 2>/dev/null | wc -l)
ELRELEASE=$(rpm -q --whatprovides redhat-release --queryformat "%{VERSION}\n" | sed 's/\/.*//' | sed 's/\..*//' | sed 's/Server*//')

echo "$MYIP4" >/var/lib/system-scripts/checkip/myip4.txt
echo "$MYIP6" >/var/lib/system-scripts/checkip/myip6.txt
echo "My IPV4 address is $(cat /var/lib/system-scripts/checkip/myip4.txt)"
echo "My IPV6 address is $(cat /var/lib/system-scripts/checkip/myip6.txt)"

touch /var/log/proftpd/auth.log
touch /var/log/fail2ban.log

systemctl enable system-scripts
systemctl enable systemmail
systemctl start system-scripts >/dev/null

chmod -Rf 755 /etc/sysconfig/system-scripts.sh
find /etc/casjaysdev/system-scripts -type f -exec chmod 0644 {} \;
find /etc/casjaysdev/system-scripts -type f -iname "*.sh" -exec chmod -f 755 {} \;
find /usr/share/system-scripts -type f -iname "*.sh" -exec chmod -f 755 {} \;
find /var/lib/system-scripts -type f -exec chmod 0644 {} \;

cat <<EOF >/etc/crontab
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=cron@$FQDN
HOME=/

# run-parts
05 * * * * root run-parts /etc/cron.hourly
00 0 * * * root run-parts /etc/cron.daily
22 0 * * 0 root run-parts /etc/cron.weekly
42 0 1 * * root run-parts /etc/cron.monthly
EOF

if [ ! -d /etc/rsync.d ]; then mkdir -p /etc/rsync.d; fi
if [ ! -f /etc/rsync.d/backup.conf ]; then
  RSYNCRANDOMNAME="backup-$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 10 | head -n 1)"
  cat <<EOF >/etc/rsync.d/backup.conf
[$RSYNCRANDOMNAME]
   path = /media/backups
   comment = backups
   uid = root
   gid = root
   read only = yes
   list = no
EOF
  echo "
The backup module name for $FQDN is $RSYNCRANDOMNAME.
You can backup using the command rsync -avhP rsync://$FQDN/$RSYNCRANDOMNAME" | mail -s "rsync module name" $MY_ADMIN_EMAIL
fi

if [ ! -f /etc/rsync.d/ftp.conf ]; then
  cat <<EOF >/etc/rsync.d/ftp.conf
[ftp]
   path = /var/ftp/pub
   comment = FTP server
   uid = ftp
   gid = ftp
   read only = yes
   list = yes
EOF
fi

cat <<EOF >/etc/logrotate.conf
# see "man logrotate" for details
# rotate log files weekly
weekly
rotate 0
create
nodateext
nocompress

# no packages own wtmp and btmp -- we'll rotate them here
/var/log/wtmp {
    monthly
    create 0664 root utmp
        minsize 1M
    rotate 0
}

/var/log/btmp {
    missingok
    monthly
    create 0600 root utmp
    rotate 0
}

include /etc/logrotate.d
EOF

if [ -f /usr/bin/dircolors ]; then
  dircolors -p >/etc/DIR_COLORS
fi

if [ -f /usr/bin/nail ]; then
  rm -f /bin/mail
  ln -s /usr/bin/nail /bin/mail
fi

if [ -f /usr/bin/vim ]; then
  rm -f /bin/vi
  ln -s /usr/bin/vim /bin/vi
fi

rm -Rf /etc/cron.*/*anacron
rm -Rf /etc/cron.*/0hourly

if [ "$ELRELEASE" -lt "7" ]; then
  if ! grep -e "/usr/share/system-scripts/hosts.sh > /dev/null 2>&1 &" /etc/rc.d/rc.local >/dev/null; then
    echo "/usr/share/system-scripts/hosts.sh > /dev/null 2>&1 &" >>/etc/rc.d/rc.local
  fi
  if ! grep -e "/usr/share/system-scripts/cron.sh > /dev/null 2>&1 &" /etc/rc.d/rc.local >/dev/null; then
    echo "/usr/share/system-scripts/cron.sh > /dev/null 2>&1 &" >>/etc/rc.d/rc.local
  fi
  if ! grep -e "sleep 5" /etc/rc.d/rc.local >/dev/null; then
    echo "sleep 5" >>/etc/rc.d/rc.local
  fi
fi

if ! grep -e "system-scripts" /etc/aliases >/dev/null; then
  echo "system-scripts:       root" >>/etc/aliases
fi

rm -Rf /etc/cron.*/*awstats*
rm -Rf /etc/cron.*/*mrtg*
rm -Rf /etc/cron.*/*webalizer*
rm -Rf /etc/cron.*/*awffull*

if [ -f /etc/casjaysdev/system-scripts/messages/000.legal.txt ]; then
  sed -i "s|myserverdomainname|$FQDN|g" /etc/casjaysdev/system-scripts/messages/000.legal.txt
fi

if [ -f /usr/bin/newaliases ]; then
  /usr/bin/newaliases >/dev/null
fi

if [ ! -d /var/log/system-scripts ]; then
  ln -s /var/lib/system-scripts/log /var/log/system-scripts
fi

if [ ! -d /var/run/system-scripts ]; then
  ln -s /var/lib/system-scripts/run /var/run/system-scripts
fi

mkdir -p /var/spool/uptimed
mkdir -p /var/lib/downtimed

touch /var/lib/system-scripts/uptime/time.up
touch /var/lib/system-scripts/uptime/date.up
touch /var/lib/system-scripts/downtime/date.down
touch /var/lib/system-scripts/downtime/time.down
touch /var/lib/downtimed/downtimedb

if [ ! -d /etc/httpd/conf/vhosts.d ]; then
  mkdir -p /etc/httpd/conf/vhosts.d
fi

if [ ! -f /etc/httpd/conf/vhosts.d/0000-default.conf ]; then
  echo -e "<VirtualHost _default_:80>
ServerAdmin ${MY_ADMIN_EMAIL:-admin@$FQDN}
ServerName $FQDN
DocumentRoot /var/www/html
</VirtualHost>" >/etc/httpd/conf/vhosts.d/0000-default.conf
fi

if [ ! -d /usr/share/httpd ]; then
  mkdir -p /usr/share/httpd
fi

if [ -d /var/www/awstats ]; then
  mv -f /var/www/awstats /usr/share/awstats
  mkdir -p /usr/share/awstats/cgi-bin
fi

if [ -d /var/www/icons ]; then
  mv -f /var/www/icons /usr/share/httpd/
fi

if [ -d /var/www/error ]; then
  mv -f /var/www/error /usr/share/httpd/
fi

if [ -d /var/www/manual ]; then
  mv -f /var/www/manual /usr/share/httpd/
fi

sed -i 's|/var/www/awstats|/usr/share/awstats|g' /etc/httpd/conf.d/awstats.conf
sed -i 's|/var/www/icons|/usr/share/httpd/icons|g' /etc/httpd/conf/httpd.conf
sed -i 's|/var/www/error|/usr/share/httpd/error|g' /etc/httpd/conf/httpd.conf
sed -i 's|/var/www/manual|/usr/share/httpd/manual|g' /etc/httpd/conf/httpd.conf

ISIP6="$(/sbin/ifconfig | grep -E "venet|inet" | grep 'inet6' | grep -i global | awk '{print $2}' | head -n1)"
if [ ! -z "$ISIP6" ]; then
  echo "IPV6 enabled so configuring for that"
  yum install -y shorewall6
  systemctl enable shorewall6
fi

echo "Installed on $(date)" >/etc/casjaysdev/system-scripts/.firstrun

source /root/bin/changeip.sh
source /etc/casjaysdev/system-scripts/systemd/uptime.sh
source /etc/casjaysdev/system-scripts/systemd/downtime.sh

systemctl enable munin-node shorewall named httpd php-fpm fail2ban snmpd proftpd
systemctl disable firewalld

echo "It is advisable that you reboot your server"

