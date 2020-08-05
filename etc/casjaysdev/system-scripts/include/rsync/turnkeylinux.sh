#Download the turnkey ISOs and LXC directories
#site is http://turnkeylinux.org
#-----------------------------------------------------------------------------------------------------------------------
RSYNCLOCKFILE="$RSYNCLOCKDIR/turnkeylinux.lock"

source /etc/casjaysdev/system-scripts/include/main/rsync.sh

#-----------------------------------------------------------------------------------------------------------------------

if [ -f $RSYNCLOCKFILE ] ; then
cat $RSYNCLOCKFILE | mail -r $MAILRECIP -s "$MAILSUB" $MAILFROM
echo "exit 10 $RSYNCLOCKFILE exists" >>$LOGFILE 2>>$ERRORLOG
exit 10
fi

echo -e "$PROG is currently Runnning on $HOSTNAME with $PROGPID" > $RSYNCLOCKFILE

#-----------------------------------------------------------------------------------------------------------------------

if [ $RSYNTURNKEYLINUX == "yes" ]; then
touch $TURNKEYLINUXLOCK
if [ ! -d $TURNKEYLINUXDIR/ISOs ]; then mkdir -p $TURNKEYLINUXDIR/ISOs ; fi
if [ ! -d $TURNKEYLINUXDIR/LXC ]; then mkdir -p $TURNKEYLINUXDIR/LXC ; fi

echo "Starting rsync for TurnkeyLinux ISOs"  >>$LOGFILE 2>>$ERRORLOG
$RSYNCCMD $MIRRORTURNKEYLINUX/$TURNKEYLINUXISOVER $TURNKEYLINUXDIR/ISOs >>$LOGFILE 2>>$ERRORLOG
echo "rsync for TurnkeyLinux complete" >>$LOGFILE 2>>$ERRORLOG

echo "Starting rsync for TurnkeyLinux LXC"  >>$LOGFILE 2>>$ERRORLOG
$RSYNCCMD $MIRRORTURNKEYLINUX/$TURNKEYLINUXLXCVER $TURNKEYLINUXDIR/LXC >>$LOGFILE 2>>$ERRORLOG
echo "rsync for TurnkeyLinux complete" >>$LOGFILE 2>>$ERRORLOG
else
echo "RSYNC TurnkeyLinux Not enabled" >>$LOGFILE 2>>$ERRORLOG
fi

#-----------------------------------------------------------------------------------------------------------------------

rm -f $RSYNCLOCKFILE

