#Download the remi RPM Directory
#site is http://rpms.remirepo.net
#-----------------------------------------------------------------------------------------------------------------------
RSYNCLOCKFILE="$RSYNCLOCKDIR/remi.lock"

source /etc/casjaysdev/system-scripts/include/main/rsync.sh

#-----------------------------------------------------------------------------------------------------------------------

if [ -f $RSYNCLOCKFILE ] ; then
cat $RSYNCLOCKFILE | mail -r $MAILRECIP -s "$MAILSUB" $MAILFROM
echo "exit 10 $RSYNCLOCKFILE exists" >>$LOGFILE 2>>$ERRORLOG
exit 10
fi

echo -e "$PROG is currently Runnning on $HOSTNAME with $PROGPID" > $RSYNCLOCKFILE

#-----------------------------------------------------------------------------------------------------------------------

if [ $RSYNCREMI == "yes" ]; then
if [ ! -d $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/remi ]; then mkdir -p $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/remi ; fi
echo "Starting RSYNC for $DIST Linux $CENTOSVER $ELARCH REMI"  >>$LOGFILE 2>>$ERRORLOG
$RSYNCCMD $MIRRORREMI/ $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/remi/ --exclude-from=$RSYNCEXCLUDEFILE >>$LOGFILE 2>>$ERRORLOG
echo "rsync for REMI complete" >>$LOGFILE 2>>$ERRORLOG
#
echo "Creating REMI REPO files for $DIST $CENTOSVER $ELARCH" >>$LOGFILE 2>>$ERRORLOG
cp -f $COMPSXMLFILE $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/remi/$COMPSXMLNAME >>$LOGFILE 2>>$ERRORLOG
cd $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/remi && $CREATEREPOCMD >>$LOGFILE 2>>$ERRORLOG
echo "Done creating REMI" >>$LOGFILE 2>>$ERRORLOG
else
echo "RSYNC REMI Not enabled" >>$LOGFILE 2>>$ERRORLOG
fi

#-----------------------------------------------------------------------------------------------------------------------

if [ $DLSRPMS == "yes" ]; then
if [ ! -d $FTPDIR/$FTPSUB/CentOS/SRPMS/$CENTOSVER/remi ]; then mkdir -p $FTPDIR/$FTPSUB/CentOS/SRPMS/$CENTOSVER/remi ; fi
$RSYNCCMD $MIRRORREMIDLSRPMS/ $FTPDIR/$FTPSUB/CentOS/SRPMS/$CENTOSVER/remi >>$LOGFILE 2>>$ERRORLOG
fi

#-----------------------------------------------------------------------------------------------------------------------

rm -Rf $RSYNCLOCKFILE

