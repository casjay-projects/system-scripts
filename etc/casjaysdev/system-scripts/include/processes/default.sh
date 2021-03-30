#System Process Check
if [ "$(
  systemctl status crond 2>/dev/null | grep running >/dev/null
  [ $? -eq 0 ] && echo "yes" || echo "no"
)" == "yes" ]; then
  echo -e "cron is running" >>$BASEDIR/$PROG/services.up
else
  echo "cron" >>$ERRORLOG
  echo -e "cron is down" >>$BASEDIR/$PROG/services.down
fi

if [ "$(
  systemctl status munin-node 2>/dev/null | grep running >/dev/null
  [ $? -eq 0 ] && echo "yes" || echo "no"
)" == "yes" ]; then
  echo -e "munin is running" >>$BASEDIR/$PROG/services.up
else
  echo "munin" >>$ERRORLOG
  echo -e "munin is down" >>$BASEDIR/$PROG/services.down
fi

if [ "$(
  systemctl status named 2>/dev/null | grep running >/dev/null
  [ $? -eq 0 ] && echo "yes" || echo "no"
)" == "yes" ]; then
  echo -e "named is running" >>$BASEDIR/$PROG/services.up
else
  echo "named" >>$ERRORLOG
  echo -e "named is down" >>$BASEDIR/$PROG/services.down
fi

if [ "$(
  systemctl status sshd 2>/dev/null | grep running >/dev/null
  [ $? -eq 0 ] && echo "yes" || echo "no"
)" == "yes" ]; then
  echo -e "ssh is running" >>$BASEDIR/$PROG/services.up
else
  echo "ssh" >>$ERRORLOG
  echo -e "ssh is down" >>$BASEDIR/$PROG/services.down
fi

if [ "$(
  systemctl status rsyslog 2>/dev/null | grep running >/dev/null
  [ $? -eq 0 ] && echo "yes" || echo "no"
)" == "yes" ]; then
  echo -e "syslog is running" >>$BASEDIR/$PROG/services.up
else
  echo "syslog" >>$ERRORLOG
  echo -e "syslog is down" >>$BASEDIR/$PROG/services.down
fi

if [ "$(
  systemctl status httpd 2>/dev/null | grep running >/dev/null
  [ $? -eq 0 ] && echo "yes" || echo "no"
)" == "yes" ]; then
  echo -e "httpd is running" >>$BASEDIR/$PROG/services.up
else
  echo "httpd" >>$ERRORLOG
  echo -e "httpd is down" >>$BASEDIR/$PROG/services.down
fi

if [ "$(
  systemctl status php-fpm 2>/dev/null | grep running >/dev/null
  [ $? -eq 0 ] && echo "yes" || echo "no"
)" == "yes" ]; then
  echo -e "php-fpm is running" >>$BASEDIR/$PROG/services.up
else
  echo "php-fpm" >>$ERRORLOG
  echo -e "php-fpm is down" >>$BASEDIR/$PROG/services.down
fi

if [ "$(
  systemctl status postfix 2>/dev/null | grep running >/dev/null
  [ $? -eq 0 ] && echo "yes" || echo "no"
)" == "yes" ]; then
  echo -e "postfix is running" >>$BASEDIR/$PROG/services.up
else
  echo "postfix" >>$ERRORLOG
  echo -e "postfix" >>$BASEDIR/$PROG/services.down
fi

if [ "$(
  systemctl status snmpd 2>/dev/null | grep running >/dev/null
  [ $? -eq 0 ] && echo "yes" || echo "no"
)" == "yes" ]; then
  echo -e "snmpd is running" >>$BASEDIR/$PROG/services.up
else
  echo "snmpd" >>$ERRORLOG
  echo -e "snmpd is down" >>$BASEDIR/$PROG/services.down
fi

if [ "$(
  systemctl status rsyncd 2>/dev/null | grep running >/dev/null
  [ $? -eq 0 ] && echo "yes" || echo "no"
)" == "yes" ]; then
  echo -e "rsync is running" >>$BASEDIR/$PROG/services.up
else
  echo "rsync" >>$ERRORLOG
  echo -e "rsync is down" >>$BASEDIR/$PROG/services.down
fi

if [ "$(
  systemctl status proftpd 2>/dev/null | grep running >/dev/null
  [ $? -eq 0 ] && echo "yes" || echo "no"
)" == "yes" ]; then
  echo -e "proftpd is running" >>$BASEDIR/$PROG/services.up
else
  echo "proftpd" >>$ERRORLOG
  echo -e "proftpd is down" >>$BASEDIR/$PROG/services.down
fi

#if [ "$(systemctl status fail2ban | grep running >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no")"  == "yes" ]; then
#echo -e "fail2ban is running" >> $BASEDIR/$PROG/services.up
#else
#echo "fail2ban" >> $ERRORLOG
#echo -e "fail2ban is down" >> $BASEDIR/$PROG/services.down
#fi

#if [ "$(systemctl status shorewall | grep active >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no")"  == "yes" ]; then
#echo -e "shorewall is running" >> $BASEDIR/$PROG/services.up
#else
#echo "shorewall" >> $ERRORLOG
#echo -e "shorewall is down" >> $BASEDIR/$PROG/services.down
#fi

#if [ -z "$CURRIP6" ]; then
#if [ "$(systemctl status shorewall6 | grep active >/dev/null ; [ $? -eq 0 ] && echo "yes" || echo "no")"  == "yes" ]; then
#echo -e "shorewall6 is running" >> $BASEDIR/$PROG/services.up
#else
#echo "shorewall6" >> $ERRORLOG
#echo -e "shorewall6 is down" >> $BASEDIR/$PROG/services.down
#fi
#fi

