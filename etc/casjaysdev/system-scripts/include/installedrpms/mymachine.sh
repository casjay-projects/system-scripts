#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0")"
VERSION="202103292329-git"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202103292329-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : WTFPL
# @ReadME        : mymachine.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Monday, Mar 29, 2021 23:29 EDT
# @File          : mymachine.sh
# @Description   : Download and save the packages installed on this system
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

yum clean all >>$LOGFILE 2>>$ERRORLOG
yum -y reinstall $(cat $RPMPKGS) --disablerepo=casjay*,myrepo-* --downloadonly --downloaddir=$MYREPOBASE/$HOSTSHORT/ >>$LOGFILE 2>>$ERRORLOG
cd $MYREPOBASE/$HOSTSHORT && $CREATEREPOCMD >>$LOGFILE 2>>$ERRORLOG

