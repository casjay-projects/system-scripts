#Download the perl CPAN directory from mirrors.rit.edu
#site is http://cpan.org
#-----------------------------------------------------------------------------------------------------------------------
RSYNCLOCKFILE="$RSYNCLOCKDIR/cpan.lock"

source /etc/casjaysdev/system-scripts/include/main/rsync.sh

#-----------------------------------------------------------------------------------------------------------------------

if [ -f $RSYNCLOCKFILE ] ; then
cat $RSYNCLOCKFILE | mail -r $MAILRECIP -s "$MAILSUB" $MAILFROM
echo "exit 10 $RSYNCLOCKFILE exists" >>$LOGFILE 2>>$ERRORLOG
exit 10
fi

echo -e "$PROG is currently Runnning on $HOSTNAME with $PROGPID" > $RSYNCLOCKFILE

#-----------------------------------------------------------------------------------------------------------------------

if [ $RSYNCCPAN == "yes" ]; then
if [ ! -d $BASECPANDIR ]; then mkdir -p $BASECPANDIR ; fi
echo "Starting rsync for CPAN"  >>$LOGFILE 2>>$ERRORLOG
$RSYNCCMD $MIRRORCPAN/ $BASECPANDIR/ >>$LOGFILE 2>>$ERRORLOG
echo "rsync for CPAN complete" >>$LOGFILE 2>>$ERRORLOG
else
echo "RSYNC CPAN Not enabled" >>$LOGFILE 2>>$ERRORLOG
fi

#-----------------------------------------------------------------------------------------------------------------------

rm -Rf $RSYNCLOCKFILE
