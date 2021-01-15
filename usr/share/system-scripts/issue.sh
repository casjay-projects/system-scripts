#!/usr/bin/env bash
PROG=issue
PROGPID=$(echo $$)
source /etc/sysconfig/system-scripts.sh
#
ERR="Process Check: Something appears to be wrong. The system Administrator has been notified!"
NOERR="Process Check: Everything appears to be running smoothly!"

if [ ! -d "$BASEDIR/$PROG" ]; then mkdir -p "$BASEDIR/$PROG"; fi

if [ -f "$PIDFILE" ]; then
  echo -e "$PROG is Already Runnning on $HOSTNAME with $PROGPID" | mail -r "$MAILRECIP" -s "$MAILSUB" "$MAILFROM"
  echo "exit 2" >"$LOGFILE" 2>"$ERRORLOG"
  exit 2
fi

echo "$PROGPID" >"$PIDFILE"

echo -e "$PROG started on $STARTDATE at $STARTTIME" >"$LOGFILE" 2>>"$ERRORLOG"

echo "" >"$COWSAYFILE"
echo "" >"$LEGALFILE"
echo "" >"$ISSUEFILE"
echo "" >"$MOTDFILE"

if [ -f "$BASEDIR/downtime/downtime" ]; then
  cat "$BASEDIR/downtime/downtime" | awk 'NF' | cowsay -f tux >"$COWSAYFILE"
fi

if [ -f "$LEGALMESS" ]; then
  echo "Legal Messages" >"$LEGALFILE"
  echo "" >>$"LEGALFILE"
  cat "$CONFDIR/messages/legal"/*.txt | grep -v '^$' | awk 'NF' >>"$LEGALFILE"
  echo "" >>"$LEGALFILE"
fi

if [ -f "$ISSUEMESS" ]; then
  echo "System Issues" >"$ISSUEFILE"
  cat "$CONFDIR/messages/issue/"*.txt | grep -v '^$' | awk 'NF' >>"$ISSUEFILE"
  echo "" >>$ISSUEMESS
fi

echo "" >"$MOTDFILE"
if [ -f "$MOTDFILE" ]; then
  echo "Message of The Day" >"$MOTDFILE"
  cat "$CONFDIR/messages/motd"/*.txt | grep -v '^$' | awk 'NF' >>"$MOTDFILE"
  echo "" >>$MOTDFILE
fi

if [ -s "$BASEDIR/processes/services.down" ]; then
  echo -e "$ERR" >>"$ISSUEFILE"
  cat "$BASEDIR/processes/services.down" | awk 'NF' >>"$ISSUEFILE"
  echo "" >>"$ISSUEFILE"
else
  echo -e "$NOERR" | awk 'NF' >>$ISSUEFILE
  echo "" >>$ISSUEFILE
fi

if [ -f "$LOGDIR/time.log" ]; then
  echo "Server uptime percentage $UP%" | awk 'NF' >>"$ISSUEFILE"
fi

echo "" >>"$ISSUEFILE"
echo "last updated on $STARTDATE at $STARTTIME" | awk 'NF' >>"$ISSUEFILE"
echo "" >>"$ISSUEFILE"

cat "$COWSAYFILE" "$LEGALFILE"" $MOTDFILE" "$ISSUEFILE" >/etc/motd
cat "$COWSAYFILE" "$LEGALFILE" "$MOTDFILE" "$ISSUEFILE" >/etc/issue

cat "$LEGALFILE" "$MOTDFILE" "$ISSUEFILE" >/etc/motd-banner
cat "$LEGALFILE" "$MOTDFILE" "$ISSUEFILE" >/etc/issue.net

if [ ! -d "$CONFDIR/include/$PROG" ]; then mkdir -p "$CONFDIR/include/$PROG"; fi
INCLUDESCRIPTS=$(ls $CONFDIR/include/$PROG/*.sh 2>/dev/null | wc -l)
if [ "$INCLUDESCRIPTS" != "0" ]; then
  for file in $"CONFDIR/include/$PROG"/*.sh; do
    source "$file"
  done
fi

ENDDATE=$(date +"%m-%d-%Y")
ENDTIME=$(date +"%r")
if [ ! -s "$ERRORLOG" ]; then
  if [ "$SENDMAIL" = "yes" ] && [ "$EMAILissue" = "yes" ]; then
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
  cat $ERRORLOG >>"$LOGFILE"
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
