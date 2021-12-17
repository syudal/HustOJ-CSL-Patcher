#!/bin/bash

#origin
#https://www.domjudge.org/
#https://github.com/DOMjudge/domjudge

#DOMjudge server installation script
#DOMjudge7.3.4 stable + Ubuntu 20.04 LTS
#Made by melongist(melongist@gmail.com, what_is_computer@msn.com) for CS teachers

#terminal commands to install DOMjudge judgehosts
#------
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj734jh.sh
#bash dj734jh.sh


if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj734jh.sh'"
  exit 1
fi

cd

sudo apt update
sudo apt -y upgrade

sudo apt -y install debootstrap


#java
sudo apt -y install default-jre-headless
sudo apt -y install default-jdk-headless
#haskell
sudo apt -y install ghc
#pascal
sudo apt -y install fp-compiler
#JavaScript
sudo apt -y install nodejs
sudo apt -y install npm
#R
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
sudo apt -y install r-base
#swift
sudo apt -y install clang libicu-dev
wget https://swift.org/builds/swift-5.5.1-release/ubuntu2004/swift-5.5.1-RELEASE/swift-5.5.1-RELEASE-ubuntu20.04.tar.gz
tar -zxvf swift-5.5.1-RELEASE-ubuntu20.04.tar.gz
rm swift-5.5.1-RELEASE-ubuntu20.04.tar.gz
sudo mv ~/swift-5.5.1-RELEASE-ubuntu20.04 ~/swift
sudo ln -s ~/swift/usr/bin/swiftc /usr/bin/swiftc


#DOMjudge 7.3.4 stable
cd domjudge-7.3.4
./configure --prefix=/opt/domjudge --with-baseurl=BASEURL

#make judgehost
make judgehost
sudo make install-judgehost

#judgehosts
#defaul judgedaemons
sudo useradd -d /nonexistent -U -M -s /bin/false domjudge-run
#multiple judgedaemons, max 64
for ((i=0; i<64; i++));
do
  sudo useradd -d /nonexistent -U -M -s /bin/false domjudge-run-$i
done

sudo cp /opt/domjudge/judgehost/etc/sudoers-domjudge /etc/sudoers.d/
sudo chmod 0440 /etc/sudoers.d/sudoers-domjudge

#try #1 for Ubuntu Desktop
sudo sed -i "s#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet cgroup_enable=memory swapaccount=1 isolcpus=2\"#" /etc/default/grub
#try #2 for Ubuntu Server
sudo sed -i "s#GRUB_CMDLINE_LINUX_DEFAULT=\"\"#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet cgroup_enable=memory swapaccount=1 isolcpus=2\"#" /etc/default/grub
#try #3 AWS Ubuntu 20.04 LTS Server
if [ -f /etc/default/grub.d/50-cloudimg-settings.cfg ]; then
	echo "Editing /etc/default/grub.d/50-cloudimg-settings.cfg for AWS"
  sudo sed -i "s#GRUB_CMDLINE_LINUX_DEFAULT=\"console=tty1 console=ttyS0 nvme_core.io_timeout=4294967295\"#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet cgroup_enable=memory swapaccount=1 isolcpus=2\"#" /etc/default/grub.d/50-cloudimg-settings.cfg
fi

#make docs
sudo apt -y install python3-sphinx python3-sphinx-rtd-theme rst2pdf fontconfig python3-yaml
make docs
sudo make install-docs

sudo update-grub

#make chroot
#default
#sudo /opt/domjudge/judgehost/bin/dj_make_chroot

#default + JavaScript,R,swift
echo 'y' | sudo /opt/domjudge/judgehost/bin/dj_make_chroot -i nodejs,r-base,swift


sudo apt -y autoremove

clear

cd
echo "" | tee -a domjudge.txt
echo "DOMjudge 7.3.4 stable 21.11.22" | tee -a domjudge.txt
echo "judgehosts installed!!" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/djstart.sh
echo "------ Run judgehosts script after every reboot ------" | tee -a domjudge.txt
echo "bash djstart.sh" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/djclear.sh
echo "------ Run DOMjudge cache clearing script when needed ------" | tee -a domjudge.txt
echo "bash djclear.sh" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "------ etc ------" | tee -a domjudge.txt
echo "How to kill some judgedaemon processe?" | tee -a domjudge.txt
echo "ps -ef, and find PID# of judgedaemon, run : sudo kill -15 PID#" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "How to clear domserver web cache?" | tee -a domjudge.txt
echo "sudo rm -rf /opt/domjudge/domserver/webapp/var/cache/prod/*" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "How to clear DOMjudge cache??" | tee -a domjudge.txt
echo "sudo /opt/domjudge/domserver/webapp/bin/console cache:clear" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
chmod 660 domjudge.txt
echo "Saved as domjudge.txt"
echo ""
echo "---- system reboot needed! ----"
echo "After rebooted, read domjudge.txt"
echo "use 'sudo reboot'"
sudo sleep 10
echo "system rebooted!"
sudo reboot
