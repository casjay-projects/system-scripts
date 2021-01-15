#!/usr/bin/env bash
PROG=createrepo
PROGPID=$(echo $$)
source /etc/sysconfig/system-scripts.sh
#
CREATEREPOLOCK="$RSYNCLOCKDIR/$LOCKFILE"

if [ -f "$PIDFILE" ]; then
  echo -e "$PROG is Already Runnning on $HOSTNAME with $PROGPID" | mail -r "$MAILRECIP" -s "$MAILSUB" "$MAILFROM"
  echo "exit 2" >"$LOGFILE" 2>"$ERRORLOG"
  exit 2
fi

if [ -f "$CREATEREPOLOCK" ]; then
  cat "$CREATEREPOLOCK" | mail -r "$MAILRECIP" -s "$MAILSUB" "$MAILFROM"
  echo "exit 10" >"$LOGFILE" 2>"$ERRORLOG"
  exit 10
fi

if [ ! -d "$BASEDIR/$PROG" ]; then mkdir -p "$BASEDIR/$PROG"; fi

if [ "$IFISBUILDSYS" == "yes" ]; then
  if [ ! -d "$MYREPOBASE/$ELARCH/$ELRELEASE"/debug ]; then mkdir -p "$MYREPOBASE/$ELARCH/$ELRELEASE"/debug; fi
  if [ ! -d "$MYREPOBASE/$ELARCH/$ELRELEASE"/rpms ]; then mkdir -p "$MYREPOBASE/$ELARCH/$ELRELEASE"/rpms; fi
  if [ ! -d "$MYREPOBASE/$ELARCH/$ELRELEASE"/srpms ]; then mkdir -p "$MYREPOBASE/$ELARCH/$ELRELEASE"/srpms; fi
  if [ ! -d "$MYREPOBASE/$ELARCH/$ELRELEASE"/extras ]; then mkdir -p "$MYREPOBASE/$ELARCH/$ELRELEASE"/extras; fi

  echo $PROGPID >$PIDFILE

  echo -e "$PROG started on $STARTDATE at $STARTTIME" >"$LOGFILE" 2>"$ERRORLOG"
  echo -e "$PROG is currently Runnning on $HOSTNAME with $PROGPID" >$CREATEREPOLOCK

  if [ "$RPMS" != "0" ]; then
    echo "Moving Packages to proper FTP directory" >>"$LOGFILE" 2>>"$ERRORLOG"
    rm -Rfv "$MYREPOBASE/$ELARCH/$ELRELEASE"/debug/*.rpm >>"$LOGFILE" 2>>"$ERRORLOG"
    rm -Rfv "$MYREPOBASE/$ELARCH/$ELRELEASE"/rpms/*.rpm >>"$LOGFILE" 2>>"$ERRORLOG"
    mv -fv "$RPMBUILDDIR/RPMS"/*/*-debuginfo-*.rpm "$MYREPOBASE/$ELARCH/$ELRELEASE"/debug >>"$LOGFILE" 2>>"$ERRORLOG"
    mv -fv "$RPMBUILDDIR/RPMS"/*/*-debugsource-*.rpm "$MYREPOBASE/$ELARCH/$ELRELEASE"/debug >>"$LOGFILE" 2>>"$ERRORLOG"
    mv -fv "$RPMBUILDDIR/RPMS"/*/*.rpm "$MYREPOBASE/$ELARCH/$ELRELEASE"/rpms >>"$LOGFILE" 2>>"$ERRORLOG"
    echo "Done moving Packages to proper FTP directory" >>"$LOGFILE" 2>>"$ERRORLOG"
  fi

  if [ "$SRPMS" != "0" ]; then
    echo "Moving Source Packages to proper FTP directory" >>"$LOGFILE" 2>>"$ERRORLOG"
    rm -Rf "$MYREPOBASE/$ELARCH/$ELRELEASE"/srpms/*.rpm >>"$LOGFILE" 2>>"$ERRORLOG"
    mv -fv "$RPMBUILDDIR/SRPMS"/*.rpm "$MYREPOBASE/$ELARCH/$ELRELEASE"/srpms >>"$LOGFILE" 2>>"$ERRORLOG"
    echo "Done moving Source Packages to proper FTP directory" >>"$LOGFILE" 2>>"$ERRORLOG"
  fi

  if [ -d "$MYREPOBASE" ]; then
    cd "$MYREPOBASE/$ELARCH/$ELRELEASE"/debug >>"$LOGFILE" 2>>"$ERRORLOG"
    echo "Currently working in $MYREPOBASE/$ELARCH/$ELRELEASE/debug" >>"$LOGFILE" 2>>"$ERRORLOG"
    "$CREATEREPOCMD" >>"$LOGFILE" 2>>"$ERRORLOG"
    cd "$MYREPOBASE/$ELARCH/$ELRELEASE"/rpms >>"$LOGFILE" 2>>"$ERRORLOG"
    echo "Currently working in $MYREPOBASE/$ELARCH/$ELRELEASE/rpms" >>"$LOGFILE" 2>>"$ERRORLOG"
    "$CREATEREPOCMD" >>"$LOGFILE" 2>>"$ERRORLOG"
    cd "$MYREPOBASE/$ELARCH/$ELRELEASE"/srpms >>"$LOGFILE" 2>>"$ERRORLOG"
    echo "Currently working in $MYREPOBASE/$ELARCH/$ELRELEASE/srpms" >>"$LOGFILE" 2>>"$ERRORLOG"
    "$CREATEREPOCMD" >>"$LOGFILE" 2>>"$ERRORLOG"
    cd "$MYREPOBASE/$ELARCH/$ELRELEASE"/extras >>"$LOGFILE" 2>>"$ERRORLOG"
    echo "Currently working in $MYREPOBASE/$ELARCH/$ELRELEASE/extras" >>"$LOGFILE" 2>>"$ERRORLOG"
    "$CREATEREPOCMD" >>"$LOGFILE" 2>>"$ERRORLOG"

  else
    echo "There doesn't seem to be a "$MYREPOBASE" repository" >>"$LOGFILE" 2>>"$ERRORLOG"
  fi
fi

if [ ! -d "$CONFDIR/include/$PROG" ]; then mkdir -p "$CONFDIR/include/$PROG"; fi
INCLUDESCRIPTS=$(ls $CONFDIR/include/$PROG/*.sh 2>/dev/null | wc -l)
if [ "$INCLUDESCRIPTS" != "0" ]; then
  for file in "$CONFDIR/include/$PROG"/*.sh; do
    source $file
  done
fi

chow -Rf ftp:ftp "$MYREPOBASE" >>"$LOGFILE" 2>>"$ERRORLOG"

ENDDATE=$(date +"%m-%d-%Y")
ENDTIME=$(date +"%r")
if [ ! -s "$ERRORLOG" ]; then
  if [ "$SENDMAIL" = "yes" ] && [ "$EMAILcreaterepo" = "yes" ]; then
    echo -e "
$MAILHEADER\n
$PROG started on $STARTDATE at $STARTTIME\n
$MAILMESS1
$MAILMESS2
$MAILMESS3
)
$PROG completed on $ENDDATE at $ENDTIME\n
$MAILFOOTER\n" | mail -r "$MAILFROM" -s "$MAILSUB" "$MAILRECIP"
  fi

else
  if [ -s "$ERRORLOG" ] && [ -f "$ERRORLOG" ] && [ "$SENDMAILONERROR" == "yes" ]; then
    MAILMESS3="$(echo -e "Errors were reported and they are as follows:\n""$(cat "$ERRORLOG")")"
    echo -e "
$MAILHEADER\n
$PROG started on $STARTDATE at $STARTTIME\n
$MAILMESS1
$MAILMESS2
$MAILMESS3
$PROG completed on $ENDDATE at $ENDTIME\n
$MAILFOOTER\n" | mail -r "$MAILFROM" -s "$MAILSUB" "$MAILRECIP"
  fi

  rm -f "$PIDFILE"
fi

if [ -s "$ERRORLOG" ]; then
  echo "Any errors from the error log are reported below" >>"$LOGFILE"
  cat "$ERRORLOG" >>"$LOGFILE"
  echo "End of error log file" >>"$LOGFILE"
fi
ENDDATE=$(date +"%m-%d-%Y")
ENDTIME=$(date +"%r")
echo -e "$PROG completed on $ENDDATE at $ENDTIME" >>"$LOGFILE" 2>>"$ERRORLOG"
echo -e "Total log Size is $(ls -lh "$LOGFILE" | awk '{print $5}')" >>"$LOGFILE" 2>>"$ERRORLOG"

rm -f "$PIDFILE"
rm -f "$ERRORLOG"
rm -f $CREATEREPOLOCK
echo "exit = $?" >>"$LOGFILE"
exit $?
