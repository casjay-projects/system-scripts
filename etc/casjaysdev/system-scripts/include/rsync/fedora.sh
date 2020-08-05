#Download the Main fedora OS Directory
#site is http://fedora.org
#-----------------------------------------------------------------------------------------------------------------------
RSYNCLOCKFILE="$RSYNCLOCKDIR/fedora.lock"

source /etc/casjaysdev/system-scripts/include/main/rsync.sh

#-----------------------------------------------------------------------------------------------------------------------

if [ -f $RSYNCLOCKFILE ] ; then
cat $RSYNCLOCKFILE | mail -r $MAILRECIP -s "$MAILSUB" $MAILFROM
echo "exit 10 $RSYNCLOCKFILE exists" >>$LOGFILE 2>>$ERRORLOG
exit 10
fi

echo -e "$PROG is currently Runnning on $HOSTNAME with $PROGPID" > $RSYNCLOCKFILE

#-----------------------------------------------------------------------------------------------------------------------

if [ $RSYNCFEDORA == "yes" ]; then
if [ ! -d $FTPDIR/$FTPSUB/Fedora/$ELARCH/$FEDORAVER/os ]; then mkdir -p $FTPDIR/$FTPSUB/Fedora/$ELARCH/$FEDORAVER/os ; fi
if [ ! -d $FTPDIR/$FTPSUB/Fedora/$ELARCH/$FEDORAVER/updates ]; then mkdir -p $FTPDIR/$FTPSUB/Fedora/$ELARCH/$FEDORAVER/updates ; fi
echo "Starting RSYNC for Fedora Linux $FEDORAVER $ELARCH Packages" >>$LOGFILE 2>>$ERRORLOG
echo "Starting rsync for the Fedora $FEDORAVER $ELARCH OS"  >>$LOGFILE 2>>$ERRORLOG
$RSYNCCMD $MIRRORFEDORA/ $FTPDIR/$FTPSUB/Fedora/$ELARCH/$FEDORAVER/os/ --exclude-from=$RSYNCEXCLUDEFILE >>$LOGFILE 2>>$ERRORLOG
$RSYNCCMD $MIRRORFEDORAUPDATE/ $FTPDIR/$FTPSUB/Fedora/$ELARCH/$FEDORAVER/updates --exclude-from=$RSYNCEXCLUDEFILE >>$LOGFILE 2>>$ERRORLOG
echo "rsync for Fedora OS complete" >>$LOGFILE 2>>$ERRORLOG
#
echo "Creating yum REPO files for Fedora $FEDORAVER $ELARCH" >>$LOGFILE 2>>$ERRORLOG
cp -f $COMPSXMLFILE $FTPDIR/$FTPSUB/Fedora/$ELARCH/$FEDORAVER/os/Packages/$COMPSXMLNAME >>$LOGFILE 2>>$ERRORLOG
cd $FTPDIR/$FTPSUB/Fedora/$ELARCH/$FEDORAVER/os/Packages/ && $CREATEREPOCMD >>$LOGFILE 2>>$ERRORLOG
echo "Creating Fedora OS Updates" >>$LOGFILE 2>>$ERRORLOG
cp -f $COMPSXMLFILE $FTPDIR/$FTPSUB/Fedora/$ELARCH/$FEDORAVER/updates/$COMPSXMLNAME >>$LOGFILE 2>>$ERRORLOG
cd $FTPDIR/$FTPSUB/Fedora/$ELARCH/$FEDORAVER/updates/ && $CREATEREPOCMD >>$LOGFILE 2>>$ERRORLOG
echo "Done creating base" >>$LOGFILE 2>>$ERRORLOG
else
echo "RSYNC OS Not enabled" >>$LOGFILE 2>>$ERRORLOG
fi

#-----------------------------------------------------------------------------------------------------------------------

if [ $DLSRPMS == "yes" ]; then
if [ ! -d $FTPDIR/$FTPSUB/Fedora/SRPMS/$FEDORAVER/os ]; then mkdir -p $FTPDIR/$FTPSUB/Fedora/SRPMS/$FEDORAVER/os ; fi
if [ ! -d $FTPDIR/$FTPSUB/Fedora/SRPMS/$FEDORAVER/updates ]; then mkdir -p $FTPDIR/$FTPSUB/Fedora/SRPMS/$FEDORAVER/updates ; fi
$RSYNCCMD $MIRRORFEDORADLSRPMS $FTPDIR/$FTPSUB/Fedora/SRPMS/$FEDORAVER/os >>$LOGFILE 2>>$ERRORLOG
$RSYNCCMD $MIRRORFEDORADLSRPMSUPDATES $FTPDIR/$FTPSUB/Fedora/SRPMS/$FEDORAVER/updates >>$LOGFILE 2>>$ERRORLOG
fi

#-----------------------------------------------------------------------------------------------------------------------

rm -Rf $RSYNCLOCKFILE
