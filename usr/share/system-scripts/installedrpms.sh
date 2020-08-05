#!/bin/bash
PROG=installedrpms
PROGPID=$(echo $$)
source /etc/sysconfig/system-scripts.sh
#
INSTALLEDRPMSLOCK="$RSYNCLOCKDIR/$HOSTSHORT.$LOCKFILE"

if [ ! -d $BASEDIR/$PROG ]; then mkdir -p $BASEDIR/$PROG ; fi
if [ ! -d $MYREPOBASE/$HOSTSHORT ] ; then mkdir -p $MYREPOBASE/$HOSTSHORT ;fi

if [ -f $PIDFILE ] ; then 
echo -e "$PROG is Already Runnning on $HOSTNAME with $PROGPID" | mail -r $MAILRECIP -s "$MAILSUB" $MAILFROM
echo "exit 2" >$LOGFILE 2>$ERRORLOG
exit 2
fi

if [ -f $INSTALLEDRPMSLOCK ] ; then
cat $INSTALLEDRPMSLOCK | mail -r $MAILRECIP -s "$MAILSUB" $MAILFROM
echo "exit 10" >$LOGFILE 2>$ERRORLOG
exit 10
fi

if [ "$IFISONLINE" -ne "0" ] ;then
echo "This system does not seam to be online" >$LOGFILE 2>>$ERRORLOG
echo -e "$HOST does not seam to be able to ping google\nPossibly not online?" | mail -r $MAILFROM -s "$MAILSUB" $MAILRECIP
echo "exit 5" >$LOGFILE 2>$ERRORLOG
exit 5
fi

echo $PROGPID > $PIDFILE
 

echo -e "$PROG started on $STARTDATE at $STARTTIME" >$LOGFILE 2>>$ERRORLOG
echo -e "$PROG is currently Runnning on $HOSTNAME with $PROGPID" > $INSTALLEDRPMSLOCK

rm -Rfv $MYREPOBASE/$HOSTSHORT/*.rpm  >>$LOGFILE 2>>$ERRORLOG

if [ ! -d $CONFDIR/include/$PROG ]; then mkdir -p $CONFDIR/include/$PROG ; fi
INCLUDESCRIPTS=$(ls $CONFDIR/include/$PROG/*.sh 2> /dev/null | wc -l)
if [ "$INCLUDESCRIPTS" != "0" ]; then
for file in $(ls $CONFDIR/include/$PROG/*.sh); do
source $file
done
fi

chmod -Rf 664 $MYREPOBASE/$HOSTSHORT >>$LOGFILE 2>>$ERRORLOG
chown -Rf ftp:ftp $MYREPOBASE/$HOSTSHORT >>$LOGFILE 2>>$ERRORLOG

ENDDATE=$(date +"%m-%d-%Y")
ENDTIME=$(date +"%r")
if [ ! -s $ERRORLOG ] ; then
if [ $SENDMAIL = "yes" ] && [ $EMAILinstalledrpms = "yes" ]; then
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

rm -f $PIDFILE
rm -f $ERRORLOG
rm -f $INSTALLEDRPMSLOCK
echo "exit = $?" >>$LOGFILE
exit $?
