system-scripts
==============
  
Various system scripts for RedHat 7 based systems  
These scripts I started working on in CentOS 6  
and have since updated to work on CentOS 7  
and they might not work on CentOS 6 anymore!  
Currently making them Fedora compatible  
I would like to at some point make them compatible with all distros.  
Doing so would require work as I am mostly RPM based.  
  
It will work on Debian based systems with some modifications.  
The packages on debian put exectuables in different locations.  
  
To install
  
```
git clone https://github.com/CasjaysDev/system-scripts.git /tmp/system-scripts
find /tmp/system-scripts/ -type f -iname ".sh" -exec chmod 755 {} \;  
find /tmp/system-scripts/ -type f -iname ".pl" -exec chmod 755 {} \;  
find /tmp/system-scripts/ -type f -iname ".cgi" -exec chmod 755 {} \;  
cp -Rf /tmp/system-scripts/{etc,root,tmp,usr,var} /  
chmod 644 -Rf /etc/cron.d/* /etc/logrotate.d/*  
rm -Rf /tmp/system-scripts  
/root/bin/changeip.sh  
```  
  
[![Patreon](https://img.shields.io/badge/patreon-donate-orange.svg)](https://www.patreon.com/casjay)
[![Paypal](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/casjaysdev)  
[![Build Status](https://travis-ci.org/CasjaysDev/system-scripts.svg?branch=master)](https://travis-ci.org/CasjaysDev/system-scripts)  
