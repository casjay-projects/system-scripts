#Enable RSYNC
RSYNCFEDORA="no"
RSYNCCENTOS="no"
RSYNCEPEL="no"
RSYNCATRPM="no"
RSYNCNUX="no"
RSYNCREMI="no"
RSYNCFUSIONFREE="no"
RSYNCFUSIONNONFREE="no"
RSYNCCPAN="no"
RSYNCPHP="no"
RSYNTURNKEYLINUX="no"
RSYNCDEBIAN="no"
RSYNCUBUNTU="no"

#CENTOS RSYNC Options
CENTOSVER="7"
MIRRORCENTOS="rsync://mirrors.rit.edu/centos/$CENTOSVER/os/$ELARCH"
MIRRORCENTOSUPDATE="rsync://mirrors.rit.edu/centos/$CENTOSVER/updates/$ELARCH/Packages"
MIRRORCENTOSSRPMS="rsync://bay.uchicago.edu/centos-vault/centos/$CENTOSVER/os/Source/SPackages"
MIRRORCENTOSSRPMSUPDATES="rsync://bay.uchicago.edu/centos-vault/centos/$CENTOSVER/updates/Source/SPackages"
MIRROREPEL="rsync://mirrors.rit.edu/epel/$CENTOSVER/$ELARCH"
MIRROREPELDLSRPMS="rsync://bay.uchicago.edu/epel/7/SRPMS/ $DLSRPMDIR/epel"

#NUX RSYNC Options
MIRRORNUX="rsync://ftp.pbone.net/pbone/mirror/li.nux.ro/download/nux/dextop/el$CENTOSVER/$ELARCH"
MIRRORNUXDLSRPMS="rsync://ftp.pbone.net/pbone/mirror/li.nux.ro/download/nux/dextop/el$CENTOSVER/SRPMS"

#REMI RSNYC Options
MIRRORREMI="rsync://mirrors.thzhost.com/remi/enterprise/$CENTOSVER/remi/$ELARCH"
MIRRORREMIDLSRPMS="rsync://fr2.rpmfind.net/linux/remi/SRPMS"

#RPMFUSION RSYNC Options
MIRRORFUSIONFREE="rsync://mirror.us.leaseweb.net/rpmfusion/nonfree/el/updates/$CENTOSVER/$ELARCH/"
MIRRORFUSIONNONFREE="rsync://mirror.us.leaseweb.net/rpmfusion/nonfree/el/updates/$CENTOSVER/$ELARCH/"
MIRRORFUSIONFREEDLSRPMS="rsync://mirror.us.leaseweb.net/rpmfusion/free/el/updates/$CENTOSVER/SRPMS"
MIRRORFUSIONNONFREESRPMS="rsync://mirror.us.leaseweb.net/rpmfusion/nonfree/el/updates/$CENTOSVER/SRPMS"

#CPAN RSYNC OPTIONS
MIRRORCPAN="rsync://mirrors.rit.edu/cpan"

#FEDORA RSYNC Options
FEDORAVER="32"
MIRRORFEDORA="rsync://mirrors.liquidweb.com/fedora/releases/$FEDORAVER/Everything/$ELARCH/os"
MIRRORFEDORAUPDATE="rsync://mirrors.liquidweb.com/fedora/updates/$FEDORAVER/$ELARCH"
MIRRORFEDORADLSRPMS="rsync://mirrors.liquidweb.com/fedora/updates/$FEDORAVER/SRPMS"
MIRRORFEDORADLSRPMSUPDATES="http://mirrors.liquidweb.com/fedora/releases/$FEDORAVER/Everything/source"

#DEBIAN RSYNC Options
DEBIANVER="10"
MIRRORDEBIAN="rsync://mirrors.liquidweb.com/debian"

#UBUNTU RSYNC Options
UNUNTUVER=20.04
MIRRORUBUNTU="rsync://mirrors.liquidweb.com/ubuntu"

#PHP RSYNC Options
MIRRORPHP="rsync://mirror.cogentco.com/PHP"

#TURNKEYLINUX RSYNC Options
MIRRORTURNKEYLINUX="rsync://mirror.turnkeylinux.org:/turnkeylinux"
TURNKEYLINUXISOVER=images/iso/*-14.2-jessie-amd64.iso
TURNKEYLINUXLXCVER=images/proxmox/*-14.2-1_amd64.tar.gz
