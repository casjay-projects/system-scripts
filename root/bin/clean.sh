#
PROG=clean
PROGPID=$(echo $$)
SYSLOGDIR=/var/log

source /etc/sysconfig/system-scripts.sh

if [ ! -d $BASEDIR/$PROG ]; then mkdir -p $BASEDIR/$PROG; fi
if [ -f /etc/cron.daily/logrotate ]; then rm -f /etc/cron.daily/logrotate; fi

if [ -f $PIDFILE ]; then
  echo -e "$PROG is already Runnning with $PROGPID"
  echo -e "$PROG is Already Runnning on $HOSTNAME with $PROGPID" | mail -r $MAILRECIP -s "$MAILSUB" $MAILFROM
  exit
else
  echo $PROGPID >$PIDFILE

  echo -e "$PROG started on $STARTDATE at $STARTTIME" >$LOGFILE
  echo "Cleaning the system"
  logrotate -f /etc/logrotate.conf >/dev/null 2>&1
  service uptimed stop >/dev/null 2>&1
  service downtimed stop >/dev/null 2>&1
  service crond stop >/dev/null 2>&1
  service munin-node stop >/dev/null 2>&1
  service httpd stop >/dev/null 2>&1
  service webmin stop >/dev/null 2>&1
  service postgresql stop >/dev/null 2>&1
  service named stop >/dev/null 2>&1
  service dhcpd stop >/dev/null 2>&1
  /bin/rm -Rf /usr/local/share/httpd/cacti/rra/* >/dev/null
  /bin/rm -Rf /var/spool/news/http/* >/dev/null
  /bin/rm -Rf /var/spool/news/http/pics/* >/dev/null
  /bin/rm -Rf /var/log/httpd/* >/dev/null
  /bin/rm -Rf /var/log/virtualmin/* >/dev/null
  /bin/rm -Rf /home/*/public_html/webalizer/* >/dev/null
  /bin/rm -Rf /var/lib/munin/html/* >/dev/null
  /bin/rm -Rf /var/lib/munin/$(hostname -f)/* >/dev/null
  /bin/rm -Rf /var/lib/munin/{datafile,datafile.storable,graphs,htmlconf.storable,limits,munin-graph.stats,munin-update.stats,plugin-state/*,state-*.storable} >/dev/null
  /bin/rm -Rf /var/lib/webalizer/webalizer.* >/dev/null
  /bin/rm -Rf /var/lib/vnstat/* >/dev/null
  /bin/rm -Rf /var/spool/uptimed/* >/dev/null
  /bin/rm -Rf /var/lib/downtimed/* >/dev/null
  /bin/rm -Rf /var/www/casjay/stats/*/*.{css,hist,png,sage_*,old,log,html} >/dev/null
  /bin/rm -Rf /var/www/casjay/stats/cacti/* >/dev/null
  /bin/rm -Rf /var/www/casjay/stats/domains/*/*/* >/dev/null
  /bin/rm -Rf /etc/webmin/bandwidth/hours/* >/dev/null
  /bin/rm -Rf /var/named/*/*.jnl >/dev/null
  /bin/rm -Rf /var/tmp/* >/dev/null
  /bin/rm -Rf /tmp/* >/dev/null
  /bin/rm -Rf /tmp/.dguardian* >/dev/null
  /bin/rm -Rf /tmp/.font-unix >/dev/null
  /bin/rm -Rf /tmp/.ICE-unix >/dev/null
  /bin/rm -Rf /tmp/.s.PGSQL.5432* >/dev/null
  /bin/rm -Rf /tmp/.wapi >/dev/null
  /bin/rm -Rf /var/lib/dhcpd/* >/dev/null
  /bin/rm -Rf /usr/share/awffull/html/* >/dev/null
  /bin/rm -Rf /usr/share/webalizer/html/* >/dev/null
  /bin/rm -Rf $SYSLOGDIR/bandwidth >/dev/null
  /bin/rm -Rf $SYSLOGDIR/*.{0,1,2,3,4,5,6,7,8,9} $SYSLOGDIR/*/*.{0,1,2,3,4,5,6,7,8,9} $SYSLOGDIR/*/*/*.{0,1,2,3,4,5,6,7,8,9} >/dev/null
  /bin/rm -Rf $SYSLOGDIR/*.gz $SYSLOGDIR/*/*.gz $SYSLOGDIR/*/*/*.gz >/dev/null
  /bin/rm -Rf $SYSLOGDIR/*.old $SYSLOGDIR/*/*.old $SYSLOGDIR/*/*/*.old >/dev/null

  mkdir -p /var/spool/news/http/pics >/dev/null

  touch /var/lib/dhcpd/dhcpd.leases >/dev/null 2>&1
  touch /var/lib/dhcpd/dhcpd6.leases >/dev/null 2>&1
  touch /var/lib/downtimed/downtimedb >/dev/null 2>&1

  chown -Rf apache:apache /var/log/httpd >/dev/null 2>&1
  chown -Rf news:news /var/spool/news/http >/dev/null 2>&1

  service named start >/dev/null 2>&1

  if [ "$halt" == "no" ]; then
    echo "Cleaning the system but not going to reboot the system"
    service crond start >/dev/null 2>&1
    service munin-node start >/dev/null 2>&1
    service httpd start >/dev/null 2>&1
    service webmin start >/dev/null 2>&1
    service postgresql start >/dev/null 2>&1
    service dhcpd start >/dev/null 2>&1
    sleep 10
    rm -Rf $PIDFILE
    rm -Rf $BASEDIR/run/*
    exit $?

  elif [ "$halt" == "yes" ]; then
    echo "shutting down system in 10 seconds"
    sleep 10
    rm -Rf $PIDFILE
    rm -Rf $BASEDIR/run/*
    poweroff -h
    exit $?

  else
    echo "restarting system in 10 seconds"
    sleep 10
    rm -Rf $PIDFILE
    rm -Rf $BASEDIR/run/*
    reboot
    exit $?
  fi
fi
exit $?
