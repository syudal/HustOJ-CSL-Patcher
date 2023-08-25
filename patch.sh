#!/bin/bash
#CSL Problem Set Import Patch Script

if [[ -z $SUDO_USER ]] ; then
  echo "Use 'sudo bash ${THISFILE}'"
  exit 1
fi

cd /home/judge/ || exit

apt-get update
apt-get -y upgrade
apt-get -y autoremove
apt-get install -y unzip

wget https://github.com/syudal/HustOJ-CSL-Patcher/archive/refs/heads/main.zip
unzip main.zip -d src
rm main.zip

chown -R www-data:www-data src/HustOJ-CSL-Patcher-main
cd src/HustOJ-CSL-Patcher-main

rm patch.sh

cp -r * ../web/
cd ../

USER=$(find /home/judge/src/web/include/db_info.inc.php | xargs grep "DB_USER" | cut --delimiter='"' --fields=2)
PASSWORD=$(find /home/judge/src/web/include/db_info.inc.php | xargs grep "DB_PASS" | cut --delimiter='"' --fields=2)
mysql -h localhost -u"$USER" -p"$PASSWORD" < web/sql/problem_csl.sql

rm -rf web/sql
rm -rf HustOJ-CSL-Patcher-main

echo "Completed patches for Galapagosized HustOJ and CSL"
