#Download the Main php source tar.gz files
#site is php.net
#-----------------------------------------------------------------------------------------------------------------------
RSYNCLOCKFILE="$RSYNCLOCKDIR/php.lock"

source /etc/casjaysdev/system-scripts/include/main/rsync.sh

#-----------------------------------------------------------------------------------------------------------------------

if [ -f $RSYNCLOCKFILE ] ; then
cat $RSYNCLOCKFILE | mail -r $MAILRECIP -s "$MAILSUB" $MAILFROM
echo "exit 10 $RSYNCLOCKFILE exists" >>$LOGFILE 2>>$ERRORLOG
exit 10
fi

echo -e "$PROG is currently Runnning on $HOSTNAME with $PROGPID" > $RSYNCLOCKFILE

#-----------------------------------------------------------------------------------------------------------------------

if [ $RSYNCPHP == "yes" ]; then
if [ ! -d $BASEPHPDIR ]; then mkdir -p $BASEPHPDIR ; fi
echo "Starting rsync for PHP"  >>$LOGFILE 2>>$ERRORLOG
$RSYNCCMD $MIRRORPHP/*.gz $BASEPHPDIR/ >>$LOGFILE 2>>$ERRORLOG
echo "rsync for PHP complete" >>$LOGFILE 2>>$ERRORLOG
else
echo "RSYNC PHP Not enabled" >>$LOGFILE 2>>$ERRORLOG
fi

#-----------------------------------------------------------------------------------------------------------------------

rm -Rf $RSYNCLOCKFILE

