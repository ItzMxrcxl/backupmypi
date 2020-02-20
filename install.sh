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
echo "First we make some Updates..."
apt update -y && apt upgrade -y
echo "Installing dependent Packages" #Begin Installation
apt install -y git rsync gzip
if [[ -d "/usr/bin/backupmypi" ]] ; then
	GITHUB_VERSION=`curl -o - https://raw.githubusercontent.com/ItzMxrcxl/backupmypi/master/ressources/usr/bin/backupmypi/version`
	LOCAL_VERSION=`cat /usr/bin/backupmypi/version`
	if [[ ! GITHUB_VERSION = LOCAL_VERSION ]]; then
		echo "Updating..."
	else
		echo "Program already installed!"
		if [[ -d "/usr/bin/backupmypi/updater.sh" ]] ; then
			echo "Running updater"
			exec /usr/bin/backupmypi/updater.sh
			exit 2
		fi
		exit 1
	fi
fi

echo "Copy files..." 
if [[ ! /usr/bin ]]; then
	echo "Created folder /usr/bin/"
	mkdir /usr/bin/
fi
if [[ ! -d "/usr/bin/backupmypi/" ]]; then
	echo "Created folder /usr/bin/backupmypi/"
	mkdir /usr/bin/backupmypi/
fi
cp ressources/usr/bin/backupmypi/* /usr/bin/backupmypi/
cp ressources/bin/* /bin/
if [[ -f "/usr/bin/backupmypi/config.txt" ]]; then
	echo -e 'WARNING: new config file has been added, please check configuration!'
	cp /usr/bin/backupmypi/config.txt /usr/bin/backupmypi/config.txt.bak
	cp /usr/bin/backupmypi/config.txt.sample /usr/bin/backupmypi/config.txt
	# echo "a backup of the configuration has been created. /usr/bin/backupmypi/config.txt"
fi
if [[ ! -f  "/usr/bin/backupmypi/config.txt" ]]; then
	cp /usr/bin/backupmypi/config.txt.sample /usr/bin/backupmypi/config.txt
fi
echo "set file permissions"
chown pi:pi /usr/bin/backupmypi #Give folder to user Pi
chmod 770 /usr/bin/backupmypi
chmod +x /bin/backup
chmod +x /usr/bin/backupmypi/*
echo "finish."
echo -e 'please edit the configuration!'
echo "nano /usr/bin/backupmypi/config.txt"
