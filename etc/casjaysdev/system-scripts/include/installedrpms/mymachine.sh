#Default script for this machine

yum clean all >>$LOGFILE 2>>$ERRORLOG
yum -y reinstall $(cat $RPMPKGS) --disablerepo=casjay*,myrepo-* --downloadonly --downloaddir=$MYREPOBASE/$HOSTSHORT/ >>$LOGFILE 2>>$ERRORLOG
cd $MYREPOBASE/$HOSTSHORT && $CREATEREPOCMD >>$LOGFILE 2>>$ERRORLOG
