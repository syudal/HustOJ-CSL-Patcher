#!/bin/bash

#DOMjudge judgehost starting script
#2023.07 Made by melongist(melongist@gmail.com) for CS teachers
#DOMjudge8.2.1 stable + Ubuntu 22.04.2 LTS + apache2 2.4.57


if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj821start.sh'"
  exit 1
fi

echo ""
#DOMjudge cache clear
sudo /opt/domjudge/domserver/webapp/bin/console cache:clear
echo "DOMjudge cache cleared!"

#DOMjudge webserver cache clear
sudo rm -rf /opt/domjudge/domserver/webapp/var/cache/prod/*
echo "DOMjudge webserver cache cleared!"

echo ""
echo "CPU information"
#check the number of CPU(s)
lscpu | grep "^CPU(s)"
CPUS=$(lscpu | grep "^CPU(s)"|awk  '{print $2}')

#Thread(s) per core
lscpu | grep "Thread(s) per core"
CORES=$(lscpu | grep "Thread(s) per core"|awk  '{print $4}')

echo ""
echo "H/W memory information"
#check the H/W memory size GiB
echo "Memory size(GiB)"
MEMS=$(free --gibi | grep "Mem:" | awk  '{print $2}')
echo "${MEMS} GiB"
echo ""

#set to H/W memory size
if [ ${MEMS} -lt 1 ] ; then
  MEMS=1
fi

MEMSNOW=$(($MEMS*40))
MEMSSET=$(grep "pm.max_children =" /etc/php/8.2/fpm/pool.d/domjudge.conf | awk '{print $3}')

if [[ $MEMSSET -ne $MEMSNOW ]] ; then
  echo ""
  echo "H/W memory size changed!!"
  echo ""
  MEMSTRING=$(grep "pm.max_children =" /etc/php/8.2/fpm/pool.d/domjudge.conf)
  NEWSTRING="pm.max_children = ${MEMSNOW}      ; ~40 per gig of memory(16gb system -> 500)"
  sudo sed -i "s:${MEMSTRING}:${NEWSTRING}:g" /etc/php/8.2/fpm/pool.d/domjudge.conf
  echo "pm.max_children value changed to ${MEMSNOW}"
  echo ""
fi

echo ""
echo "Restarting php..."
sudo service php8.2-fpm restart
sudo service php8.2-fpm reload
echo ""
echo "Restarting mariadb..."
sudo systemctl restart mariadb
echo ""
WEBSERVER=$(curl -is localhost | grep "Server" | awk '{sub(/\/*/, ""); print $2}')
if [[ "$WEBSERVER" == "Apache*" ]] ; then
  echo "Restarting apache2..."
  sudo systemctl restart apache2
  sudo systemctl reload apache2
fi
if [[ "$WEBSERVER" == "nginx" ]] ; then
  echo "Restarting nginx..."
  sudo systemctl restart nginx
  sudo systemctl reload nginx
fi

echo ""
echo "Starting create cgroups..."
sudo /opt/domjudge/judgehost/bin/create_cgroups
echo "create cgroups started!"

echo ""
echo "Starting judgedaemon..."
#kill current judgedaemons
kill -9 `pgrep -f judgedaemon`

#start new judgedaemons
#default judgedaemon
sudo -u $USER DOMJUDGE_CREATE_WRITABLE_TEMP_DIR=1 setsid /opt/domjudge/judgehost/bin/judgedaemon &
echo "judgedaemon-run started!"
#multi judgedaemons, limited to the number of cores, max 128
for ((i=1; i<${CPUS}; i++));
do
  echo "start judgedaemon-run-$i..."
  sudo -u $USER DOMJUDGE_CREATE_WRITABLE_TEMP_DIR=1 setsid /opt/domjudge/judgehost/bin/judgedaemon -n $i &
  echo "judgedaemon-run-$i started!"
done

echo ""
echo "$CPUS judgedamons started!"
echo ""
