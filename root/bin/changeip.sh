#!/bin/sh
if [ ! -f /usr/sbin/ifconfig ]; then
echo -e "The net-tools package is not installed
and therefore I can not continue!
It can be installed with the command yum install -y net-tools"
exit 1
fi

mkdir -p /var/lib/system-scripts/checkip /etc/casjaysdev
#DOMAIN
OLDDOM="myserverdomainname"
NEWDOM="$(hostname -f)"
#ShortHostname
OLDSHORT="myhostnameshort"
NEWSHORT="$(hostname -s)"
#IP4
OLDIP4="01234567890"
NEWIP4="$(/sbin/ifconfig | grep -E "venet|inet" | grep -v "127.0.0." | grep 'inet' | grep -v inet6 | awk '{print $2}' | sed s#addr:##g | head -n1)"
#IP6
OLDIP6="11:11:11:11::11"
NEWIP6="$(/sbin/ifconfig | grep -E "venet|inet" | grep 'inet6' | grep -i global | awk '{print $2}' | head -n1)"
#
#IPV4
/sbin/ifconfig | grep -E "venet|inet" | grep -v "127.0.0." | grep 'inet' | grep -v inet6 | awk '{print $2}' | sed "s#addr:##g" | head -n1 > /var/lib/system-scripts/checkip/myip4.txt
if [ -z "$NEWIP4" ]; then
echo no ipv4
else
echo ipv4 works so continuing with IPV4 changes
find /root -type f -exec sed -i "s#$OLDIP4#$NEWIP4#g" {} \;  > /dev/null 2>&1
find /etc/httpd/conf* -type f -exec sed -i "s#$OLDIP4#$NEWIP4#g" {} \;  > /dev/null 2>&1
find /etc/proftpd* -type f -exec sed -i "s#$OLDIP4#$NEWIP4#g" {} \;  > /dev/null 2>&1
find /etc/postfix -type f -exec sed -i "s#$OLDIP4#$NEWIP4#g" {} \;  > /dev/null 2>&1
find /etc/hosts* -type f -exec sed -i "s#$OLDIP4#$NEWIP4#g" {} \;  > /dev/null 2>&1
find /etc/issue* -type f -exec sed -i "s#$OLDIP4#$NEWIP4#g" {} \;  > /dev/null 2>&1
find /etc/motd* -type f -exec sed -i "s#$OLDIP4#$NEWIP4#g" {} \;  > /dev/null 2>&1
find /etc/named -type f -exec sed -i "s#$OLDIP4#$NEWIP4#g" {} \;  > /dev/null 2>&1
find /var/www -type f -exec sed -i "s#$OLDIP4#$NEWIP4#g" {} \;  > /dev/null 2>&1
find /var/named -type f -exec sed -i "s#$OLDIP4#$NEWIP4#g" {} \;  > /dev/null 2>&1
find /etc/webmin -type f -exec sed -i "s#$OLDIP4#$NEWIP4#g" {} \;  > /dev/null 2>&1
#find /etc/usermin -type f -exec sed -i "s#$OLDIP4#$NEWIP4#g" {} \;  > /dev/null 2>&1
find /var/lib/system-scripts -type f -exec sed -i "s#$OLDIP4#$NEWIP4#g" {} \;  > /dev/null 2>&1
find /etc/casjaysdev/system-scripts -type f -exec sed -i "s#$OLDIP4#$NEWIP4#g" {} \;  > /dev/null 2>&1
fi
#IPV6
/sbin/ifconfig | grep -E "venet|inet" | grep 'inet6' | grep -i global | awk '{print $2}' | head -n1 > /var/lib/system-scripts/checkip/myip6.txt
if [ -z "$NEWIP6" ]; then
echo no ipv6
find /etc/httpd/conf* -type f -exec sed -i "s#\[2604:6000:ffc0:1:7dbc:544f:bf02:c93a\]:443##g" {} \;  > /dev/null 2>&1
else
echo ipv6 works so continuing with IPV6 changes
find /root -type f -exec sed -i "s#$OLDIP6#$NEWIP6#g" {} \;  > /dev/null 2>&1
find /etc/postfix -type f -exec sed -i "s#$OLDIP6#$NEWIP6#g" {} \;  > /dev/null 2>&1
find /etc/httpd/conf* -type f -exec sed -i "s#$OLDIP6#$NEWIP6#g" {} \;  > /dev/null 2>&1
find /etc/proftpd* -type f -exec sed -i "s#$OLDIP6#$NEWIP6#g" {} \;  > /dev/null 2>&1
find /etc/named -type f -exec sed -i "s#$OLDIP6#$NEWIP6#g" {} \;  > /dev/null 2>&1
find /var/named -type f -exec sed -i "s#$OLDIP6#$NEWIP6#g" {} \;  > /dev/null 2>&1
find /var/www -type f -exec sed -i "s#$OLDIP6#$NEWIP6#g" {} \;  > /dev/null 2>&1
find /etc/hosts* -type f -exec sed -i "s#$OLDIP6#$NEWIP6#g" {} \;  > /dev/null 2>&1
find /etc/issue* -type f -exec sed -i "s#$OLDIP6#$NEWIP6#g" {} \;  > /dev/null 2>&1
find /etc/motd* -type f -exec sed -i "s#$OLDIP6#$NEWIP6#g" {} \;  > /dev/null 2>&1
find /etc/webmin -type f -exec sed -i "s#$OLDIP6#$NEWIP6#g" {} \;  > /dev/null 2>&1
find /etc/casjaysdev -type f -exec sed -i "s#$OLDIP6#$NEWIP6#g" {} \;  > /dev/null 2>&1
find /var/lib/system-scripts -type f -exec sed -i "s#$OLDIP6#$NEWIP6#g" {} \;  > /dev/null 2>&1
fi
#Domain
find /root -type f -exec sed -i "s#$OLDDOM#$NEWDOM#g" {} \;  > /dev/null 2>&1
find /etc/postfix -type f -exec sed -i "s#$OLDDOM#$NEWDOM#g" {} \;  > /dev/null 2>&1
find /etc/httpd/conf* -type f -exec sed -i "s#$OLDDOM#$NEWDOM#g" {} \;  > /dev/null 2>&1
find /etc/proftpd* -type f -exec sed -i "s#$OLDDOM#$NEWDOM#g" {} \;  > /dev/null 2>&1
find /etc/named -type f -exec sed -i "s#$OLDDOM#$NEWDOM#g" {} \;  > /dev/null 2>&1
find /var/named -type f -exec sed -i "s#$OLDDOM#$NEWDOM#g" {} \;  > /dev/null 2>&1
find /var/www -type f -exec sed -i "s#$OLDDOM#$NEWDOM#g" {} \;  > /dev/null 2>&1
find /etc/hosts* -type f -exec sed -i "s#$OLDDOM#$NEWDOM#g" {} \;  > /dev/null 2>&1
find /etc/issue* -type f -exec sed -i "s#$OLDDOM#$NEWDOM#g" {} \;  > /dev/null 2>&1
find /etc/motd* -type f -exec sed -i "s#$OLDDOM#$NEWDOM#g" {} \;  > /dev/null 2>&1
find /etc/munin -type f -exec sed -i "s#$OLDDOM#$NEWDOM#g" {} \;  > /dev/null 2>&1
find /etc/rc.d/rc.local -type f -exec sed -i "s#$OLDDOM#$NEWDOM#g" {} \;  > /dev/null 2>&1
find /etc/cron* -type f -exec sed -i "s#$OLDDOM#$NEWDOM#g" {} \;  > /dev/null 2>&1
find /etc/casjaysdev -type f -exec sed -i "s#$OLDDOM#$NEWDOM#g" {} \;  > /dev/null 2>&1
find /etc/webmin -type f -exec sed -i "s#$OLDDOM#$NEWDOM#g" {} \;  > /dev/null 2>&1
find /etc/webalizer* -type f -exec sed -i "s#$OLDDOM#$NEWDOM#g" {} \;  > /dev/null 2>&1
find /etc/uptimed.conf -type f -exec sed -i "s#$OLDDOM#$NEWDOM#g" {} \;  > /dev/null 2>&1
find /etc/casjaysdev -type f -exec sed -i "s#$OLDDOM#$NEWDOM#g" {} \;  > /dev/null 2>&1
find /var/lib/system-scripts -type f -exec sed -i "s#$OLDDOM#$NEWDOM#g" {} \;  > /dev/null 2>&1
#Change Short HostName
find /root -type f -exec sed -i "s#$OLDSHORT#$NEWSHORT#g" {} \;  > /dev/null 2>&1
find /etc/casjaysdev -type f -exec sed -i "s#$OLDSHORT#$NEWSHORT#g" {} \;  > /dev/null 2>&1
find /etc/httpd/conf* -type f -exec sed -i "s#$OLDSHORT#$NEWSHORT#g" {} \;  > /dev/null 2>&1
if [ ! -z "$NEWIP4" ]; then echo "Changed the IP4 from $OLDIP4 to $NEWIP4" ; fi
if [ ! -z "$NEWIP6" ]; then echo "Changed the IP6 from $OLDIP6 to $NEWIP6" ; fi
echo "Changed the DOMAIN from $OLDDOM to $NEWDOM"
echo "Changed the HOSTNAME from $OLDSHORT to $NEWSHORT"
