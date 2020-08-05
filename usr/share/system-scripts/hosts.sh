#!/bin/bash
PROG=hosts
PROGPID=$(echo $$)
source /etc/sysconfig/system-scripts.sh
#
HOSTS=$MYHOSTS

if [ ! -d $BASEDIR/$PROG ]; then mkdir -p $BASEDIR/$PROG ; fi

if [ -f $PIDFILE ] ; then 
echo -e "$PROG is Already Runnning on $HOSTNAME with $PROGPID" | mail -r $MAILRECIP -s "$MAILSUB" $MAILFROM
echo "exit 2" >$LOGFILE 2>$ERRORLOG
exit 2
fi

echo $PROGPID > $PIDFILE

echo -e "$PROG started on $STARTDATE at $STARTTIME" > $LOGFILE

###USER CONFIG ENDS HERE###


# Check for required non-bash commands.
#
CMDS=( ping bc mv sleep )
for CMD in ${CMDS[@]:0}; do
  if [[ `which $CMD 2>/dev/null` = "" ]] ; then
   echo "$CMD not found. Exiting."
  exit
  fi
done

# Some vars.
#
NUM=0
RUNS=1
LOOP=1
LOG=$LOGDIR/time.log

# Check if logfile exists and make a backup if it does.
#
#if [ -e $LOG ]; then
#mv $LOG $LOG.bak
#fi

# Declare a variable for each host to store amount of downs in
# and set these variables to 0.
#
for IP in ${HOSTS[@]:0}; do
let "NUM += 1"
declare "DOWNVAR$NUM"=0
done

# Check if host is up or down.
#
PINGER (){
PING=`ping -c1 -w1 $IP|grep rtt`
test "$PING" != "" && STATEUP || STATEDOWN
}

# Stuff to do when host is up.
#
STATEUP (){
STATE=" UP "
COLOR="\E[1;32m"  ## Green
UP_CALC
}

# Stuff to do when host is down.
#
STATEDOWN (){
STATE=DOWN
COLOR="\E[1;31m" ## Red
let "DOWNVAR$NUM += 1"
UP_CALC
}

# Calculate uptime in %.
# Also adjust output based on value. Purely cosmetic.
#
UP_CALC () {
UP=`echo "scale=2; 100-(100*$((DOWNVAR$NUM))/$RUNS)"|bc`
# Cosmetic stuff starts here.
if [[ $UP = 100.00 ]]; then
   UPECHO="$UP%"
  elif [[ $UP > 9 ]]; then
   UPECHO=" $UP%"
  elif [[ $UP = 0 ]]; then
   UPECHO="  0.00%"
  else UPECHO=" $UP%"
fi
}

# Console output.
#
OUTHEADER () {
echo -e " STATE \tIP \t\t UPTIME"
echo --------------------------------
}
OUTPUT () {
echo -ne "$COLOR $STATE \t" && tput sgr0
echo -e "$IP \t $UPECHO"
}

# Logfile output.
#
OUTHEADERLOG () {
echo -e "IP \t\t  UPTIME"
echo -------------------------
}
OUTPUTLOG () {
echo -e "$IP \t  $UPECHO"
}

# Script shows how many times it has run.
# This function adds 1 to that value after each cycle.
#
CYCLERUNS (){
let "RUNS += 1"
}

# Main loop starts here.
#
until [ $LOOP = 0 ]; do
clear
NUM=0
OUTHEADER
OUTHEADERLOG > $LOG
for IP in ${HOSTS[@]:0}; do
  let "NUM += 1"
  PINGER
  OUTPUT
  OUTPUTLOG >> $LOG
done
echo "Runs: $RUNS"
echo "Runs: $RUNS" >> $LOG
CYCLERUNS
sleep 60
done

ENDDATE=$(date +"%m-%d-%Y")
ENDTIME=$(date +"%r")
if [ ! -s $ERRORLOG ] ; then
if [ $SENDMAIL = "yes" ] && [ $EMAILhosts = "yes" ]; then
echo -e "
$MAILHEADER\n
$PROG started on $STARTDATE at $STARTTIME\n
$MAILMESS1
$MAILMESS2
$MAILMESS3
$PROG completed on $ENDDATE at $ENDTIME\n
$MAILFOOTER\n"| mail -r $MAILFROM -s "$MAILSUB" $MAILRECIP
fi

else
if [ -s $ERRORLOG ] && [ -f $ERRORLOG ] && [ $SENDMAILONERROR == "yes" ]; then
MAILMESS3="$(echo -e "Errors were reported and they are as follows:\n""$(cat $ERRORLOG)")"
echo -e "
$MAILHEADER\n
$PROG started on $STARTDATE at $STARTTIME\n
$MAILMESS1
$MAILMESS2
$MAILMESS3
$PROG completed on $ENDDATE at $ENDTIME\n
$MAILFOOTER\n"| mail -r $MAILFROM -s "$MAILSUB" $MAILRECIP
fi

rm -f $PIDFILE
fi

if [ -s $ERRORLOG ]; then
echo "Any errors from the error log are reported below" >> $LOGFILE
cat $ERRORLOG >> $LOGFILE
echo "End of error log file" >> $LOGFILE
fi
ENDDATE=$(date +"%m-%d-%Y")
ENDTIME=$(date +"%r")
echo -e "$PROG completed on $ENDDATE at $ENDTIME" >>$LOGFILE 2>>$ERRORLOG
echo -e "Total log Size is $(ls -lh $LOGFILE | awk '{print $5}')" >>$LOGFILE 2>>$ERRORLOG

rm -f $ERRORLOG
rm -f $PIDFILE
echo "exit = $?" >>$LOGFILE
exit $?

