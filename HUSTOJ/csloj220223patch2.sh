#!/bin/bash
#CSL HUSTOJ
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teachers

clear

THISFILE="csloj220223patch2.sh"

if [[ -z $SUDO_USER ]]
then
  echo "Use 'sudo bash ${THISFILE}'"
  exit 1
fi

#docker disabling
sed -i "s/OJ_USE_DOCKER=1/OJ_USE_DOCKER=0/g" /home/judge/etc/judge.conf
sed -i "s/OJ_INTERNAL_CLIENT=1/OJ_INTERNAL_CLIENT=0/g" /home/judge/etc/judge.conf

sed -i "s/release 22.02.23p1 /release 22.02.23p2/" /home/judge/src/web/template/bs3/js.php

echo ""
echo "---- CSL HUSTOJ pending error patched ----"
echo ""
echo "---- system reboot ----"
echo ""
echo "Waiting 10 seconds..."
sleep 10
echo "Rebooted"
reboot
