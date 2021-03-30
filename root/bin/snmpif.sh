#!/usr/bin/env bash
host="${1:-$host}"
if [ -z $host ]; then host=localhost; fi
snmpwalk -v1 -c public $host .1.3.6.1.2.1.2.2.1.2 -v1 -c public $host .1.3.6.1.2.1.2.2.1.2
