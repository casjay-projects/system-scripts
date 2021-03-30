#!/bin/bash
PROG=backuphome
PROGPID=$(echo $$)
source /etc/sysconfig/system-scripts.sh
#

if [ ! -d "$BASEDIR/$PROG" ]; then mkdir -p "$BASEDIR/$PROG"; fi
if [ ! -d "$BACKUPDIR" ]; then mkdir -p "$BACKUPDIR"; fi

if [ -f $PIDFILE ]; then
  echo -e "$PROG is Already Runnning on $HOSTNAME with $PROGPID" | mail -r "$MAILRECIP" -s "$MAILSUB" "$MAILFROM"
  echo "exit 2" >$LOGFILE 2>$ERRORLOG
  exit 2
fi

echo "$PROGPID" >"$PIDFILE"

echo -e "$PROG started on $STARTDATE at $STARTTIME" >"$LOGFILE" 2>"$ERRORLOG"
echo -e "Sleeping randomly ($SLEEPCMD) seconds before running" >>"$LOGFILE" 2>>"$ERRORLOG"
echo -e "This will help if you have this script running on multiple servers" >>"$LOGFILE" 2>>"$ERRORLOG"
rm -Rfv "$BACKUPDIR/$TWOBACKUPHOMENAME" >>"$LOGFILE" 2>>"$ERRORLOG"
sleep "$SLEEPCMD"
tar cvpfz "$BACKUPDIR/$BACKUPHOMENAME" --directory=/home /var/www --files-from="$INCLUDEFILE" --exclude-from="$EXCLUDEFILE" >>"$LOGFILE" 2>>"$ERRORLOG"

if [ ! -d "$CONFDIR/include/$PROG" ]; then mkdir -p "$CONFDIR/include/$PROG"; fi
INCLUDESCRIPTS=$(ls $CONFDIR/include/$PROG/*.sh 2>/dev/null | wc -l)
if [ "$INCLUDESCRIPTS" != "0" ]; then
  for file in "$CONFDIR/include/$PROG"/*.sh; do
    source "$file"
  done
fi

ENDDATE=$(date +"%m-%d-%Y")
ENDTIME=$(date +"%r")
if [ ! -s "$ERRORLOG" ]; then
  if [ "$SENDMAIL" = "yes" ] && [ "$EMAILbackuphome" = "yes" ]; then
    echo -e "
$MAILHEADER\n
$PROG started on $STARTDATE at $STARTTIME\n
$MAILMESS1
$MAILMESS2
$MAILMESS3
$PROG completed on $ENDDATE at $ENDTIME\n
$MAILFOOTER\n" | mail -r "$MAILFROM" -s "$MAILSUB" "$MAILRECIP"
  fi

else
  if [ -s "$ERRORLOG" ] && [ -f "$ERRORLOG" ] && [ "$SENDMAILONERROR" == "yes" ]; then
    MAILMESS3="$(echo -e "Errors were reported and they are as follows:\n""$(cat $ERRORLOG)")"
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
echo -e "Total log Size is $(ls -lh $LOGFILE | awk '{print $5}')" >>"$LOGFILE" 2>>"$ERRORLOG"

rm -f "$ERRORLOG"
rm -f "$PIDFILE"
echo "exit = $?" >>"$LOGFILE"
exit $?

