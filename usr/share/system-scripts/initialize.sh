#!/usr/bin/env bash
PROG=initial
PROGPID=$(echo $$)
source /etc/sysconfig/system-scripts.sh
#

if [ ! -d "$BASEDIR/$PROG" ]; then mkdir -p "$BASEDIR/$PROG"; fi

if [ -f "$PIDFILE" ]; then
  echo -e "$PROG is Already Runnning on $HOSTNAME with $PROGPID" | mail -r "$MAILRECIP" -s "$MAILSUB" "$MAILFROM"
  echo "exit 2" >>"$LOGFILE" 2>>"$ERRORLOG"
  exit 2
fi

echo "$PROGPID" >"$PIDFILE"

echo -e "$PROG started on $STARTDATE at $STARTTIME" >>"$LOGFILE" 2>>"$ERRORLOG"

[ -d /usr/local/share/httpd ] || mkdir -p /usr/local/share/httpd
[ -d /var/www/awstats ] && mv -f /var/www/awstats /usr/share/awstats && mkdir -p /usr/share/awstats/cgi-bin
[ -d /var/www/icons ] && mv -f /var/www/icons /usr/local/share/httpd/
[ -d /var/www/error ] && mv -f /var/www/error /usr/local/share/httpd/
[ -d /var/www/manual ] && mv -f /var/www/manual /usr/local/share/httpd/
[ -f /etc/httpd/conf.d/awstats.conf ] && sed -i 's|/var/www/awstats|/usr/share/awstats|g' /etc/httpd/conf.d/awstats.conf

if [ -f /etc/httpd/conf/httpd.conf ]; then
  sed -i 's|/var/www/icons|/usr/local/share/httpd/icons|g' /etc/httpd/conf/httpd.conf
  sed -i 's|/var/www/error|/usr/local/share/httpd/error|g' /etc/httpd/conf/httpd.conf
  sed -i 's|/var/www/manual|/usr/local/share/httpd/manual|g' /etc/httpd/conf/httpd.conf
fi
if [ -f "$(command -v cpan 2>/dev/null)" ]; then
  cpan Bit::Vector Carp::Clan Date::Calc Digest::SHA1 Compress::Zlib Net::DNS Archive::Tar Archive::Zip Archive::Rar
  cpan IO::Stringy Mail::Internet Net::Server Convert::UUlib MIME::Base64 MIME::Parser
  cpan Convert::TNEF Digest::MD5 Time::HiRes Unix::Syslog Mail::SPF::Query Net::SMTP BerkeleyDB
fi
if [ -f "$(command -v razor-admin 2>/dev/null)" ]; then
  razor-admin -d -create >>"$LOGFILE" 2>>"$ERRORLOG"
  razor-admin -register >>"$LOGFILE" 2>>"$ERRORLOG"
  razor-admin -d -create -home=/var/amavis/.razor/ >>"$LOGFILE" 2>>"$ERRORLOG"
fi
[ -f "$(command -v pyzor 2>/dev/null)" ] && pyzor discover >>"$LOGFILE" 2>>"$ERRORLOG"
[ -d /root/.razor/ ] && [ -d /var/amavis/ ] && cp -Rf /root/.razor/. /var/amavis/ >>"$LOGFILE" 2>>"$ERRORLOG"
[ -f /root/.razor/razor-agent.conf ] && sed -i 's#razorhome =.*#razorhome = /var/amavis/.razor#g' /root/.razor/razor-agent.conf >>"$LOGFILE" 2>>"$ERRORLOG"
[ -f /root/.razor/razor-agent.conf ] && sed -i 's|3|0|g' /root/.razor/razor-agent.conf >>"$LOGFILE" 2>>"$ERRORLOG"
[ -f /etc/dcc/dcc_conf ] && sed -i 's|DCCIFD_ENABLE=off|DCCIFD_ENABLE=on|g' /etc/dcc/dcc_conf >>"$LOGFILE" 2>>"$ERRORLOG"
if [ -d /etc/mail/spamassassin ]; then
  echo "loadplugin Mail::SpamAssassin::Plugin::DCC" >/etc/mail/spamassassin/v310.pre
  echo "loadplugin Mail::SpamAssassin::Plugin::Pyzor" >>/etc/mail/spamassassin/v310.pre
  echo "loadplugin Mail::SpamAssassin::Plugin::Razor2" >>/etc/mail/spamassassin/v310.pre
  echo "loadplugin Mail::SpamAssassin::Plugin::SpamCop" >>/etc/mail/spamassassin/v310.pre
  echo "#loadplugin Mail::SpamAssassin::Plugin::AntiVirus" >>/etc/mail/spamassassin/v310.pre
  echo "loadplugin Mail::SpamAssassin::Plugin::AWL" >>/etc/mail/spamassassin/v310.pre
  echo "loadplugin Mail::SpamAssassin::Plugin::AutoLearnThreshold" >>/etc/mail/spamassassin/v310.pre
  echo "#loadplugin Mail::SpamAssassin::Plugin::TextCat" >>/etc/mail/spamassassin/v310.pre
  echo "#loadplugin Mail::SpamAssassin::Plugin::AccessDB" >>/etc/mail/spamassassin/v310.pre
  echo "loadplugin Mail::SpamAssassin::Plugin::WhiteListSubject" >>/etc/mail/spamassassin/v310.pre
  echo "#loadplugin Mail::SpamAssassin::Plugin::DomainKeys" >>/etc/mail/spamassassin/v310.pre
  echo "loadplugin Mail::SpamAssassin::Plugin::MIMEHeader" >>/etc/mail/spamassassin/v310.pre
  echo "loadplugin Mail::SpamAssassin::Plugin::ReplaceTags" >>/etc/mail/spamassassin/v310.pre
  echo "razor_config /var/amavis/.razor/razor-agent.conf" >>/etc/mail/spamassassin/local.cf
  echo "bayes_path /var/amavis/.spamassassin/bayes" >>/etc/mail/spamassassin/local.cf
  echo "auto_whitelist_path /var/amavis/.spamassassin/auto-whitelist" >>/etc/mail/spamassassin/local.cf
  echo "lock_method flock" >>/etc/mail/spamassassin/local.cf
  echo "add_header all Status _YESNO_, score=_SCORE_ required=_REQD_ tests=_TESTSSCORES(,)_ _DCCR_ _PYZOR_ _RBL_ autolearn=_AUTOLEARN_ version=_VERSION_" >>/etc/mail/spamassassin/local.cf
  echo "dcc_home /var/dcc" >>/etc/mail/spamassassin/local.cf
fi
if [ -f /etc/cron.d/dccd ]; then
  echo "0 5 * * * /usr/bin/cron-dccd" >/etc/cron.d/dccd
  echo "chown -R amavis:amavis /var/amavis /var/dcc" >>/etc/cron.d/dccd
fi

[ -d /usr/libexec/dcc ] && chkconfig --add DCC >>"$LOGFILE" 2>>"$ERRORLOG"
[ -f /usr/libexec/dcc/rcDCC ] && cp -f /usr/libexec/dcc/rcDCC /etc/rc.d/init.d/DCC >>"$LOGFILE" 2>>"$ERRORLOG"
[ -f /usr/libexec/dcc/cron-dccd ] && ln -s /usr/libexec/dcc/cron-dccd /usr/bin/cron-dccd >>"$LOGFILE" 2>>"$ERRORLOG"

[ -d /var/amavis/.pyzor ] || mkdir -p /var/amavis/.pyzor/ >>"$LOGFILE" 2>>"$ERRORLOG"
[ -f /root/.pyzor/servers ] && cp /root/.pyzor/servers /var/amavis/.pyzor/ >>"$LOGFILE" 2>>"$ERRORLOG"

if [ -f "$(command -v pyzor 2>/dev/null)" ]; then
  cdcc "delete 127.0.0.1" >>"$LOGFILE" 2>>"$ERRORLOG"
  cdcc "delete 127.0.0.1 Greylist" >>"$LOGFILE" 2>>"$ERRORLOG"
fi

spamassassin --lint -D >>"$LOGFILE" 2>>"$ERRORLOG"
cp -ir /root/.spamassassin /var/amavis >>"$LOGFILE" 2>>"$ERRORLOG"

sa-learn --sync >>"$LOGFILE" 2>>"$ERRORLOG"
chown -R amavis:amavis /var/amavis/ >>"$LOGFILE" 2>>"$ERRORLOG"
chown -R amavis:amavis /var/dcc >$LOGFILE 2>>"$ERRORLOG"
chmod -R 750 /var/amavis >$LOGFILE 2>>"$ERRORLOG"

rm -f /razor-agent.log

service amavisd restart >>"$LOGFILE" 2>>"$ERRORLOG"
service DCC restart >>"$LOGFILE" 2>>"$ERRORLOG"
service dovecot restart >>"$LOGFILE" 2>>"$ERRORLOG"
service spamassassin restart >>"$LOGFILE" 2>>"$ERRORLOG"
service postfix restart >>"$LOGFILE" 2>>"$ERRORLOG"

ENDDATE=$(date +"%m-%d-%Y")
ENDTIME=$(date +"%r")
if [ ! -s "$ERRORLOG" ]; then
  if [ "$SENDMAIL" = "yes" ] && [ "$EMAILinitialize" = "yes" ]; then
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
