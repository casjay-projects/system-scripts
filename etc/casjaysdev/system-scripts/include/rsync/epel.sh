#Download the EPEL RPMS from mirrors.rit.edu/epel
#Site is https://fedoraproject.org/wiki/EPEL
#-----------------------------------------------------------------------------------------------------------------------
RSYNCLOCKFILE="$RSYNCLOCKDIR/epel.lock"

source /etc/casjaysdev/system-scripts/include/main/rsync.sh

#-----------------------------------------------------------------------------------------------------------------------

if [ -f $RSYNCLOCKFILE ] ; then
cat $RSYNCLOCKFILE | mail -r $MAILRECIP -s "$MAILSUB" $MAILFROM
echo "exit 10 $RSYNCLOCKFILE exists" >>$LOGFILE 2>>$ERRORLOG
exit 10
fi

echo -e "$PROG is currently Runnning on $HOSTNAME with $PROGPID" > $RSYNCLOCKFILE

#-----------------------------------------------------------------------------------------------------------------------

if [ $RSYNCEPEL == "yes" ]; then
if [ ! -d $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/epel ]; then mkdir -p $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/epel ; fi
echo "Starting RSYNC for $DIST Linux $CENTOSVER $ELARCH EPEL"  >>$LOGFILE 2>>$ERRORLOG
$RSYNCCMD $MIRROREPEL/ $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/epel/ --exclude-from=$RSYNCEXCLUDEFILE >>$LOGFILE 2>>$ERRORLOG
echo "rsync for EPEL complete" >>$LOGFILE 2>>$ERRORLOG
#
echo "Creating epel REPO files for $DIST $CENTOSVER $ELARCH" >>$LOGFILE 2>>$ERRORLOG
cp -f $COMPSXMLFILE $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/epel/$COMPSXMLNAME >>$LOGFILE 2>>$ERRORLOG
cd $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/epel && $CREATEREPOCMD >>$LOGFILE 2>>$ERRORLOG
echo "Done creating epel" >>$LOGFILE 2>>$ERRORLOG
else
echo "RSYNC EPEL Not enabled" >>$LOGFILE 2>>$ERRORLOG
fi

#-----------------------------------------------------------------------------------------------------------------------

if [ $DLSRPMS == "yes" ]; then
if [ ! -d $DLSRPMDIR/epel ]; then mkdir -p $DLSRPMDIR/epel ; fi
$RSYNCCMD $MIRROREPELDLSRPMS/ $DLSRPMDIR/epel >>$LOGFILE 2>>$ERRORLOG
fi

#-----------------------------------------------------------------------------------------------------------------------

rm -Rf $RSYNCLOCKFILE

