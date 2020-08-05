#Download the Main CentOS OS Directory
#site is http://centos.org
#-----------------------------------------------------------------------------------------------------------------------
RSYNCLOCKFILE="$RSYNCLOCKDIR/centos.lock"

source /etc/casjaysdev/system-scripts/include/main/rsync.sh

if [ -f $RSYNCLOCKFILE ] ; then
cat $RSYNCLOCKFILE | mail -r $MAILRECIP -s "$MAILSUB" $MAILFROM
echo "exit 10 $RSYNCLOCKFILE exists" >>$LOGFILE 2>>$ERRORLOG
exit 10
fi

echo -e "$PROG is currently Runnning on $HOSTNAME with $PROGPID" > $RSYNCLOCKFILE

#-----------------------------------------------------------------------------------------------------------------------

if [ $RSYNCCENTOS == "yes" ]; then
if [ ! -d $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/os ]; then mkdir -p $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/os ; fi
if [ ! -d $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/updates ]; then mkdir -p $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/updates ; fi
echo "Starting RSYNC for CentOS Linux $CENTOSVER $ELARCH Packages" >>$LOGFILE 2>>$ERRORLOG
echo "Starting rsync for the CentOS $CENTOSVER $ELARCH OS"  >>$LOGFILE 2>>$ERRORLOG
$RSYNCCMD $MIRRORCENTOS/ $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/os/ --exclude-from=$RSYNCEXCLUDEFILE >>$LOGFILE 2>>$ERRORLOG
$RSYNCCMD $MIRRORCENTOSUPDATE/ $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/updates --exclude-from=$RSYNCEXCLUDEFILE >>$LOGFILE 2>>$ERRORLOG
echo "rsync for CentOS OS complete" >>$LOGFILE 2>>$ERRORLOG
#
echo "Creating yum REPO files for CentOS $CENTOSVER $ELARCH" >>$LOGFILE 2>>$ERRORLOG
cp -f $COMPSXMLFILE $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/os/Packages/$COMPSXMLNAME >>$LOGFILE 2>>$ERRORLOG
cd $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/os/Packages/ && $CREATEREPOCMD >>$LOGFILE 2>>$ERRORLOG
echo "Creating OS Updates" >>$LOGFILE 2>>$ERRORLOG
cp -f $COMPSXMLFILE $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/updates/$COMPSXMLNAME >>$LOGFILE 2>>$ERRORLOG
cd $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/updates/ && $CREATEREPOCMD >>$LOGFILE 2>>$ERRORLOG
echo "Done creating base" >>$LOGFILE 2>>$ERRORLOG
else
echo "RSYNC OS Not enabled" >>$LOGFILE 2>>$ERRORLOG
fi

#-----------------------------------------------------------------------------------------------------------------------

if [ $DLSRPMS == "yes" ]; then
if [ ! -d $FTPDIR/$FTPSUB/CentOS/SRPMS/$CENTOSVER/os ]; then mkdir -p $FTPDIR/$FTPSUB/CentOS/SRPMS/$CENTOSVER/os ; fi
if [ ! -d $FTPDIR/$FTPSUB/CentOS/SRPMS/$CENTOSVER/updates ]; then mkdir -p $FTPDIR/$FTPSUB/CentOS/SRPMS/$CENTOSVER/updates ; fi
$RSYNCCMD $MIRRORCENTOSSRPMS/ $FTPDIR/$FTPSUB/CentOS/SRPMS/$CENTOSVER/os >>$LOGFILE 2>>$ERRORLOG
$$RSYNCCMD $RSYNCCMD $MIRRORCENTOSSRPMSUPDATES/ $FTPDIR/$FTPSUB/CentOS/SRPMS/$CENTOSVER/updates >>$LOGFILE 2>>$ERRORLOG

fi

#-----------------------------------------------------------------------------------------------------------------------

rm -Rf $RSYNCLOCKFILE
