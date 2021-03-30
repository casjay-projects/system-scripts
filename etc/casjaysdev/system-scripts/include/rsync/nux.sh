#Download the NUX RPM Directory
#site is https://li.nux.ro/repos.html
#-----------------------------------------------------------------------------------------------------------------------
RSYNCLOCKFILE="$RSYNCLOCKDIR/nux.lock"

source /etc/casjaysdev/system-scripts/include/main/rsync.sh

#-----------------------------------------------------------------------------------------------------------------------

if [ -f $RSYNCLOCKFILE ] ; then
cat $RSYNCLOCKFILE | mail -r $MAILRECIP -s "$MAILSUB" $MAILFROM
echo "exit 10 $RSYNCLOCKFILE exists" >>$LOGFILE 2>>$ERRORLOG
exit 10
fi

echo -e "$PROG is currently Runnning on $HOSTNAME with $PROGPID" > $RSYNCLOCKFILE

#-----------------------------------------------------------------------------------------------------------------------

if [ $RSYNCNUX == "yes" ]; then
if [ ! -d $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/nux ]; then mkdir -p $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/nux ; fi
echo "Starting RSYNC for $DIST Linux $CENTOSVER $ELARCH NUX"  >>$LOGFILE 2>>$ERRORLOG
$RSYNCCMD $MIRRORNUX/ $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/nux/ --exclude-from=$RSYNCEXCLUDEFILE >>$LOGFILE 2>>$ERRORLOG
echo "rsync for NUX complete" >>$LOGFILE 2>>$ERRORLOG
#
echo "Creating NUX REPO files for $DIST $CENTOSVER $ELARCH" >>$LOGFILE 2>>$ERRORLOG
cp -f $COMPSXMLFILE $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/nux/$COMPSXMLNAME >>$LOGFILE 2>>$ERRORLOG
cd $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/nux && $CREATEREPOCMD >>$LOGFILE 2>>$ERRORLOG
echo "Done creating NUX" >>$LOGFILE 2>>$ERRORLOG
else
echo "RSYNC NUX Not enabled" >>$LOGFILE 2>>$ERRORLOG
fi

#-----------------------------------------------------------------------------------------------------------------------
#Download the source rpms
if [ $DLSRPMS == "yes" ]; then
if [ ! -d $FTPDIR/$FTPSUB/CentOS/SRPMS/$CENTOSVER/nux ]; then mkdir -p $FTPDIR/$FTPSUB/CentOS/SRPMS/$CENTOSVER/nux ; fi
$RSYNCCMD $MIRRORNUXDLSRPMS/ $FTPDIR/$FTPSUB/CentOS/SRPMS/$CENTOSVER/nux >>$LOGFILE 2>>$ERRORLOG
fi

#-----------------------------------------------------------------------------------------------------------------------

rm -Rf $RSYNCLOCKFILE

