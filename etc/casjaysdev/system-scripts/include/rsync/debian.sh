#Download the debian packages
#site is http://debian.org
#-----------------------------------------------------------------------------------------------------------------------
RSYNCLOCKFILE="$RSYNCLOCKDIR/ubuntu.lock"

source /etc/casjaysdev/system-scripts/include/main/rsync.sh

#-----------------------------------------------------------------------------------------------------------------------

if [ -f $RSYNCLOCKFILE ] ; then
cat $RSYNCLOCKFILE | mail -r $MAILRECIP -s "$MAILSUB" $MAILFROM
echo -e "$PROG is currently Runnning on $HOSTNAME with $PROGPID" > $RSYNCLOCKFILE
echo "exit 10 $RSYNCLOCKFILE exists" >>$LOGFILE 2>>$ERRORLOG
exit 10
fi

echo -e "$PROG is currently Runnning on $HOSTNAME with $PROGPID" > $RSYNCLOCKFILE

#-----------------------------------------------------------------------------------------------------------------------

if [ $RSYNCDEBIAN == "yes" ]; then
if [ ! -d $FTPDIR/$FTPSUB/Debian ]; then mkdir -p $FTPDIR/$FTPSUB/Debian ; fi
echo "Starting rsync for Debian"  >>$LOGFILE 2>>$ERRORLOG
$RSYNCCMD $MIRRORDEBIAN $FTPDIR/$FTPSUB/Debian/ >>$LOGFILE 2>>$ERRORLOG
echo "rsync for Debian complete" >>$LOGFILE 2>>$ERRORLOG
else
echo "RSYNC Not enabled for Debian" >>$LOGFILE 2>>$ERRORLOG
fi

#-----------------------------------------------------------------------------------------------------------------------

rm -Rf $RSYNCLOCKFILE

