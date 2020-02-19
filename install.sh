#!/bin/bash
# Author: Marcel Kallinger https://github.com/ItzMxrcxl
# Open Source BackupMyPi Script

if [ "$EUID" -ne 0 ]
  then echo "Please run as root" && echo "sudo install.sh"
  exit 5
fi

echo "~~~~~~~~~~~~~~~~BackupMyPi~~~~~~~~~~~~~~~~"
echo "Author: Marcel Kallinger"
echo "https://github.com/ItzMxrcxl"
echo ""
echo "Before installing we make some Updates..."
apt update -y && apt upgrade -y
echo "Installing dependent Packages" #Begin Installation
apt install -y git rsync gzip
if "/usr/bin/backupmypi" ; then
	echo "Program already installed!"
	if "/usr/bin/backupmypi/updater.sh" ; then
		echo "Running updater"
		exec /usr/bin/backupmypi/updater.sh
		exit 2
	fi
	exit 1
else
	echo "Copy files..." 
	if [[ ! /usr/bin ]]; then
		mkdir /usr/bin/
	fi	
	mkdir /usr/bin/backupmypi/
	cp ressources/usr/bin/backupmypi/* /usr/bin/backupmypi/
	cp ressources/bin/* /bin/
	if [[ /usr/bin/backupmypi/config.txt ]]; then
		echo -e "${RED} WARNING: "
		cp /usr/bin/backupmypi/config.txt /usr/bin/backupmypi/config.txt.bak
		# cp /usr/bin/backupmypi/config.txt.sample /usr/bin/backupmypi/config.txt
	fi
	if [[ ! /usr/bin/backupmypi/config.txt ]]; then
		cp /usr/bin/backupmypi/config.txt.sample /usr/bin/backupmypi/config.txt
	fi
	echo "set file permissions"
	chown pi:pi /usr/bin/backupmypi #Give folder to user Pi
	chmod 770 /usr/bin/backupmypi
	chmod +x /bin/backup
	chmod +x /usr/bin/backupmypi/*
	echo "finish."
	echo -e "${RED}please edit the configuration!"
	echo "nano /usr/bin/backupmypi/config.txt"
fi