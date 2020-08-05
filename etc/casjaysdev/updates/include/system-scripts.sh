#!/bin/sh

PACKAGE=system-scripts
NEWVERSION="$(echo $(curl -s https://raw.githubusercontent.com/CasjaysDev/system-scripts/master/version.txt | tail -n 1))"
OLDVERSION="$(echo $(cat /etc/casjaysdev/updates/versions/system-scripts.txt | tail -n 1))"
URL="https://github.com/CasjaysDev/system-scripts/archive/master.tar.gz"
FILENAME="update.tar.gz"
TMPDIR="/tmp/casjaysdev/$PACKAGE"
CASJAYSDEV="/etc/casjaysdev/updates"
WGETCMD="wget -q"
TARCMD="tar xfz"

mkdir -p $TMPDIR $CASJAYSDEV

if [ "$NEWVERSION" == "$OLDVERSION" ]; then
echo "No update available"
exit 0
fi

echo "Updating $PACKAGE"
if [[ $NEWVERSION =~ .*git.* ]]; then
git clone https://github.com/CasjaysDev/system-scripts.git $TMPDIR/
rm -Rf $TMPDIR/doc
rm -Rf $TMPDIR/CODE_OF_CONDUCT.md
rm -Rf $TMPDIR/LICENSE
rm -Rf $TMPDIR/README.md
rm -Rf $TMPDIR/version.txt
else
$WGETCMD "$URL" -O $TMPDIR/$FILENAME
$TARCMD $TMPDIR/$FILENAME -C $TMPDIR
rm -Rf $TMPDIR/$FILENAME
fi

for f in $(cat $TMPDIR/tmp/$PACKAGE.deleted.txt) ; do rm -Rf "/$f" ; done

rm -Rf $TMPDIR/etc/casjaysdev/system-scripts/messages
rm -Rf $TMPDIR/etc/cron.d
rm -Rf $TMPDIR/var/lib/system-scripts/*/*.txt

if [ -f $TMPDIR/tmp/update.sh ]; then
source $TMPDIR/tmp/update.sh
else
cp -Rf $TMPDIR/etc/* /etc/
cp -Rf $TMPDIR/root/* /root/
cp -Rf $TMPDIR/usr/* /usr/
cp -Rf $TMPDIR/var/* /var/
fi

rm -Rf $TMPDIR
echo "The $PACKAGE on $(hostname -f) has been updated from version $OLDVERSION to version $NEWVERSION" | mail -s "$(hostname -s) has been updated" "root@$(hostname -f)"

/root/bin/changeip.sh

echo -e "$NEWVERSION" > /etc/casjaysdev/updates/versions/system-scripts.txt