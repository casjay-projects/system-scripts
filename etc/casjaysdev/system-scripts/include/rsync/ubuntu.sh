#Download the ubuntu packages
#site is http://ubuntu.com
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

if [ $RSYNCUBUNTU == "yes" ]; then
if [ ! -d $FTPDIR/$FTPSUB/Ubuntu ]; then mkdir -p $FTPDIR/$FTPSUB/Ubuntu ; fi
echo "Starting rsync for Ubuntu"  >>$LOGFILE 2>>$ERRORLOG
$RSYNCCMD $MIRRORUBUNTU $FTPDIR/$FTPSUB/Ubuntu/ >>$LOGFILE 2>>$ERRORLOG
echo "rsync for Ubuntu complete" >>$LOGFILE 2>>$ERRORLOG
else
echo "RSYNC Not enabled for Ubuntu" >>$LOGFILE 2>>$ERRORLOG
fi

#-----------------------------------------------------------------------------------------------------------------------

rm -Rf $RSYNCLOCKFILE
