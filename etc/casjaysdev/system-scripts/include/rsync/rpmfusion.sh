#Download the rpmfusion RPM Directory
#site is http://rpmfusion.org
#-----------------------------------------------------------------------------------------------------------------------
RSYNCLOCKFILE="$RSYNCLOCKDIR/rpmfusion.lock"

source /etc/casjaysdev/system-scripts/include/main/rsync.sh

#-----------------------------------------------------------------------------------------------------------------------

if [ -f $RSYNCLOCKFILE ] ; then
cat $RSYNCLOCKFILE | mail -r $MAILRECIP -s "$MAILSUB" $MAILFROM
echo "exit 10 $RSYNCLOCKFILE exists" >>$LOGFILE 2>>$ERRORLOG
exit 10
fi

echo -e "$PROG is currently Runnning on $HOSTNAME with $PROGPID" > $RSYNCLOCKFILE

#-----------------------------------------------------------------------------------------------------------------------

if [ $RSYNCFUSIONFREE == "yes" ]; then
if [ ! -d $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/fusion/free ]; then mkdir -p $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/fusion/free ; fi
echo "Starting RSYNC for $DIST Linux $CENTOSVER $ELARCH rpmfusion-free"  >>$LOGFILE 2>>$ERRORLOG
$RSYNCCMD $MIRRORFUSIONFREE/ $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/fusion/free --exclude-from=$RSYNCEXCLUDEFILE >>$LOGFILE 2>>$ERRORLOG
echo "rsync for rpmfusion-free complete" >>$LOGFILE 2>>$ERRORLOG
#
echo "Creating RPMFusion Free REPO files for $DIST $CENTOSVER $ELARCH" >>$LOGFILE 2>>$ERRORLOG
cp -f $COMPSXMLFILE $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/fusion/free/$COMPSXMLNAME >>$LOGFILE 2>>$ERRORLOG
cd $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/fusion/free && $CREATEREPOCMD >>$LOGFILE 2>>$ERRORLOG
echo "Done creating RPMFusion Free" >>$LOGFILE 2>>$ERRORLOG
else
echo "RSYNC FUSIONFREE Not enabled" >>$LOGFILE 2>>$ERRORLOG
fi

if [ $RSYNCFUSIONNONFREE == "yes" ]; then
if [ ! -d $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/fusion/nonfree ]; then mkdir -p $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/fusion/nonfree ; fi
echo "Starting RSYNC for $DIST Linux $CENTOSVER $ELARCH rpmfusion-nonfree"  >>$LOGFILE 2>>$ERRORLOG
$RSYNCCMD $MIRRORFUSIONNONFREE/ $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/fusion/nonfree --exclude-from=$RSYNCEXCLUDEFILE >>$LOGFILE 2>>$ERRORLOG
echo "rsync for rpmfusion-nonfree complete" >>$LOGFILE 2>>$ERRORLOG
#
echo "Creating RPMFusion NonFree REPO files for $DIST $CENTOSVER $ELARCH" >>$LOGFILE 2>>$ERRORLOG
cp -f $COMPSXMLFILE $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/fusion/nonfree/$COMPSXMLNAME >>$LOGFILE 2>>$ERRORLOG
cd $FTPDIR/$FTPSUB/CentOS/$ELARCH/$CENTOSVER/fusion/nonfree && $CREATEREPOCMD >>$LOGFILE 2>>$ERRORLOG
echo "Done creating RPMFusion NonFree" >>$LOGFILE 2>>$ERRORLOG
else
echo "RSYNC FUSIONNONFREE Not enabled" >>$LOGFILE 2>>$ERRORLOG
fi

#-----------------------------------------------------------------------------------------------------------------------

if [ $DLSRPMS == "yes" ]; then
if [ ! -d $FTPDIR/$FTPSUB/CentOS/SRPMS/$CENTOSVER/rpmfusion/free ]; then mkdir -p $FTPDIR/$FTPSUB/CentOS/SRPMS/$CENTOSVER/rpmfusion/free ; fi
if [ ! -d $FTPDIR/$FTPSUB/CentOS/SRPMS/$CENTOSVER/rpmfusion/nonfree ]; then mkdir -p $FTPDIR/$FTPSUB/CentOS/SRPMS/$CENTOSVER/rpmfusion/nonfree ; fi
$RSYNCCMD $MIRRORFUSIONFREEDLSRPMS/ $FTPDIR/$FTPSUB/CentOS/SRPMS/$CENTOSVER/rpmfusion/free >>$LOGFILE 2>>$ERRORLOG
$RSYNCCMD $MIRRORFUSIONNONFREESRPMS/ $FTPDIR/$FTPSUB/CentOS/SRPMS/$CENTOSVER/rpmfusion/nonfree >>$LOGFILE 2>>$ERRORLOG
fi

#-----------------------------------------------------------------------------------------------------------------------

rm -Rf $RSYNCLOCKFILE
