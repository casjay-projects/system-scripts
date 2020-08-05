#!/bin/sh
while true; do nc -l 80 < /var/www/html/test.html; done
