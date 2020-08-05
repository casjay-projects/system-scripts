#!/bin/bash
#This script should be copied to $BASE/include/processes/
#as it will be most likely overwritten on update
PROG=processes
PROGPID=$(echo $$)
source /etc/sysconfig/system-scripts.sh
#
ERR="Process Check: Something appears to be wrong. The system Administrator has been notified!"
NOERR="Process Check: Everything appears to be running smoothly!"

if [ ! -d $BASEDIR/$PROG ]; then mkdir -p $BASEDIR/$PROG ; fi

if [ -f $PIDFILE ] ; then 
echo -e "$PROG is Already Runnning on $HOSTNAME with $PROGPID" | mail -r $MAILRECIP -s "$MAILSUB" $MAILFROM
echo "exit 2" >$LOGFILE 2>$ERRORLOG
exit 2
fi

echo -e "$PROG started on $STARTDATE at $STARTTIME" > $LOGFILE

rm -f $BASEDIR/$PROG/services.up
rm -f $BASEDIR/$PROG/services.down

if [ "`systemctl show -p ActiveState clamd@amavisd.service | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status clamd@amavisd.service | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then
#echo -e "clamav is running" >> $BASEDIR/$PROG/services.up
#else
#echo "Clamd" >> $ERRORLOG
#echo -e "clamav is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState ices* | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status ices* | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then
#echo -e "ices is running" >> $BASEDIR/$PROG/services.up
#else
#echo "ices" >> $ERRORLOG
#echo -e "ices is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState cups | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status cups | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "cups is running" >> $BASEDIR/$PROG/services.up
#else
#echo "cups" >> $ERRORLOG
#echo -e "cups is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState dansguardian | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status dansguardian | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "dansguardian is running" >> $BASEDIR/$PROG/services.up
#else
#echo "dansguardian" >> $ERRORLOG
#echo -e "dansguardian is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState dhcpd | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status dhcpd | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "dhcpd is running" >> $BASEDIR/$PROG/services.up
#else
#echo "dhcpd" >> $ERRORLOG
#echo -e "dhcpd is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState dhcpd6 | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status dhcpd6 | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "dhcpd6 is running" >> $BASEDIR/$PROG/services.up
#else
#echo "dhcpd" >> $ERRORLOG
#echo -e "dhcpd6 is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState radvd | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status radvd | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "radvd is running" >> $BASEDIR/$PROG/services.up
#else
#echo "radvd" >> $ERRORLOG
#echo -e "radvd is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState dovecot | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status dovecot | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "dovecot is running" >> $BASEDIR/$PROG/services.up
#else
#echo "dovecot" >> $ERRORLOG
#echo -e "dovecot is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState icecast | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status icecast | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "icecast is running" >> $BASEDIR/$PROG/services.up
#else
#echo "icecast" >> $ERRORLOG
#echo -e "icecast is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState mailgraph | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status mailgraph | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "mailgraph is running" >> $BASEDIR/$PROG/services.up
#else
#echo "mailgraph" >> $ERRORLOG
#echo -e "mailgraph is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState mailman | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status mailman | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "mailman is running" >> $BASEDIR/$PROG/services.up
#else
#echo "mailman" >> $ERRORLOG
#echo -e "mailman is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState mediatomb | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status mediatomb | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "mediatomb is running" >> $BASEDIR/$PROG/services.up
#else
#echo "mediatomb" >> $ERRORLOG
#echo -e "mediatomb is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState mon | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status mon | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "mon is running" >> $BASEDIR/$PROG/services.up
#else
#echo "mon" >> $ERRORLOG
#echo -e "mon is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState mt-daap | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status mt-daap | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "mt-daap is running" >> $BASEDIR/$PROG/services.up
#else
#echo "mt-daap" >> $ERRORLOG
#echo -e "mt-daap is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState mysql | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status mysql | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "mysql is running" >> $BASEDIR/$PROG/services.up
#else
#echo "mysql" >> $ERRORLOG
#echo -e "mysql is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState innd | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status innd | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "innd is running" >> $BASEDIR/$PROG/services.up
#else
#echo "innd" >> $ERRORLOG
#echo -e "innd is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState ntpd | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status ntpd | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "ntpd is running" >> $BASEDIR/$PROG/services.up
#else
#echo "ntpd" >> $ERRORLOG
#echo -e "ntpd is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState nut-server | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status nut-server | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "ups is running" >> $BASEDIR/$PROG/services.up
#else
#echo "ups" >> $ERRORLOG
#echo -e "ups is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState nut-monitor | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status nut-monitor | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "upsmon is running" >> $BASEDIR/$PROG/services.up
#else
#echo "upsmon" >> $ERRORLOG
#echo -e "upsmon is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState openfire | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status openfire | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "openfire is running" >> $BASEDIR/$PROG/services.up
#else
#echo "openfire" >> $ERRORLOG
#echo -e "openfire is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState ldap | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status ldap | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "ldap is running" >> $BASEDIR/$PROG/services.up
#else
#echo "ldap" >> $ERRORLOG
#echo -e "ldap is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState pgsql | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status pgsql | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "pgsql is running" >> $BASEDIR/$PROG/services.up
#else
#echo "pgsql" >> $ERRORLOG
#echo -e "pgsql is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState pptpd | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status pptpd | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "pptpd is running" >> $BASEDIR/$PROG/services.up
#else
#echo "pptpd" >> $ERRORLOG
#echo -e "pptpd is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState radius | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status radius | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "radius is running" >> $BASEDIR/$PROG/services.up
#else
#echo "radius" >> $ERRORLOG
#echo -e "radius is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState saslauthd | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status saslauthd | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "sasl is running" >> $BASEDIR/$PROG/services.up
#else
#echo "sasl" >> $ERRORLOG
#echo -e "sasl is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState slpd | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status slpd | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "slpd is running" >> $BASEDIR/$PROG/services.up
#else
#echo "slpd" >> $ERRORLOG
#echo -e "slpd is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState smb | cut -d'=' -f2`" == active ] && [ "`systemctl show -p ActiveState nmb | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status smb nmb | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "samba is running" >> $BASEDIR/$PROG/services.up
#else
#echo "samba" >> $ERRORLOG
#echo -e "samba is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState amavisd | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status amavisd | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "amavisd is running" >> $BASEDIR/$PROG/services.up
#else
#echo "amavisd" >> $ERRORLOG
#echo -e "amavisd is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState spamassassin | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status spamassassin | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then
#echo -e "spamd is running" >> $BASEDIR/$PROG/services.up
#else
#echo "spamd" >> $ERRORLOG
#echo -e "spamd is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState squid | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status squid | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "squid is running" >> $BASEDIR/$PROG/services.up
#else
#echo "squid" >> $ERRORLOG
#echo -e "squid is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState uptimed | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status uptimed | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "uptimed is running" >> $BASEDIR/$PROG/services.up
#else
#echo "uptimed" >> $ERRORLOG
#echo -e "uptimed is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState downtimed | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status downtimed | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "downtimed is running" >> $BASEDIR/$PROG/services.up
#else
#echo "downtimed" >> $ERRORLOG
#echo -e "downtimed is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ "`systemctl show -p ActiveState xinetd | cut -d'=' -f2`" == active ]; then
#if [ "`systemctl status xinetd | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no"  `"  == "yes" ]; then 
#echo -e "xinetd is running" >> $BASEDIR/$PROG/services.up
#else
#echo "xinetd" >> $ERRORLOG
#echo -e "xinetd is down" >> $BASEDIR/$PROG/services.down
#fi
fi

if [ ! -d $CONFDIR/include/$PROG ]; then mkdir -p $CONFDIR/include/$PROG ; fi
INCLUDESCRIPTS=$(ls $CONFDIR/include/$PROG/*.sh 2> /dev/null | wc -l)
if [ "$INCLUDESCRIPTS" != "0" ]; then
for file in $(ls $CONFDIR/include/$PROG/*.sh); do
source $file
done
fi

ENDDATE=$(date +"%m-%d-%Y")
ENDTIME=$(date +"%r")
if [ ! -s $ERRORLOG ] ; then
if [ $SENDMAIL = "yes" ] && [ $EMAILprocesses = "yes" ]; then
echo -e "
$MAILHEADER\n
$PROG started on $STARTDATE at $STARTTIME\n
$MAILMESS1
$MAILMESS2
$MAILMESS3
$PROG completed on $ENDDATE at $ENDTIME\n
$MAILFOOTER\n"| mail -r $MAILFROM -s "$MAILSUB" $MAILRECIP
fi

else
if [ -s $ERRORLOG ] && [ -f $ERRORLOG ] && [ $SENDMAILONERROR == "yes" ]; then
MAILMESS3="$(echo -e "Errors were reported and they are as follows:\n""$(cat $ERRORLOG)")"
echo -e "
$MAILHEADER\n
$PROG started on $STARTDATE at $STARTTIME\n
$MAILMESS1
$MAILMESS2
$MAILMESS3
$PROG completed on $ENDDATE at $ENDTIME\n
$MAILFOOTER\n"| mail -r $MAILFROM -s "$MAILSUB" $MAILRECIP
fi

rm -f $PIDFILE
fi

if [ -s $ERRORLOG ]; then
echo "Any errors from the error log are reported below" >> $LOGFILE
cat $ERRORLOG >> $LOGFILE
echo "End of error log file" >> $LOGFILE
fi
ENDDATE=$(date +"%m-%d-%Y")
ENDTIME=$(date +"%r")
echo -e "$PROG completed on $ENDDATE at $ENDTIME" >>$LOGFILE 2>>$ERRORLOG
echo -e "Total log Size is $(ls -lh $LOGFILE | awk '{print $5}')" >>$LOGFILE 2>>$ERRORLOG

rm -f $ERRORLOG
rm -f $PIDFILE
echo "exit = $?" >>$LOGFILE
exit $?

