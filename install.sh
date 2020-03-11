#!/bin/bash
# Author: Marcel Kallinger https://github.com/ItzMxrcxl
# BackupMyPi Script

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root or with sudo" 
	echo "sudo install.sh"
	exit 5
fi

echo "~~~~~~~~~~~~~~~~BackupMyPi - Installer~~~~~~~~~~~~~~~~"
echo "Author: Marcel Kallinger"
echo "https://github.com/ItzMxrcxl"
echo ""
echo "First we make some Updates..."
apt update -y && apt upgrade -y
echo "Installing dependent Packages" #Begin Installation
apt install -y git rsync gzip pv exfat-fuse exfat-utils cifs-utils curlftpfs

if [[ -d "/usr/bin/backupmypi" ]] ; then
	GITHUB_VERSION=`curl --silent -H 'Cache-Control: no-cache' -o - https://raw.githubusercontent.com/ItzMxrcxl/backupmypi/master/ressources/usr/bin/backupmypi/version`
	LOCAL_VERSION=$installed_version
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

echo "create envoirement"
if [[ ! /usr/bin ]]; then
	echo "Created folder /usr/bin/"
	mkdir /usr/bin/
fi
if [[ ! -d "/usr/bin/backupmypi/" ]]; then
	echo "Created folder /usr/bin/backupmypi/"
	mkdir /usr/bin/backupmypi/
	mkdir /usr/bin/backupmypi/tmp
fi

echo "Download PiShrink"
wget https://raw.githubusercontent.com/ItzMxrcxl/PiShrink/master/pishrink.sh
echo "Installing PiShrink"
sudo mv pishrink.sh /bin/pishrink
chmod +x /bin/pishrink

echo "Copy Programm data"
cp ressources/usr/bin/backupmypi/* /usr/bin/backupmypi/
echo "Copy Programm"
cp ressources/bin/* /bin/

source /usr/bin/backupmypi/update.notes
if [[ $update_config = "true" ]]; then
	echo -e 'WARNING: new config file has been added, please check configuration!'
	cp /usr/bin/backupmypi/config.txt /usr/bin/backupmypi/config.txt.bak
	echo "a backup of the configuration has been created. /usr/bin/backupmypi/config.txt.bak"
	cp /usr/bin/backupmypi/config.txt.sample /usr/bin/backupmypi/config.txt
fi
if [[ ! -f  "/usr/bin/backupmypi/config.txt" ]]; then
	msg_config_created="true"
	cp /usr/bin/backupmypi/config.txt.sample /usr/bin/backupmypi/config.txt
	echo "Created Config file"
fi
echo "set permissions"
chown pi:pi /usr/bin/backupmypi #Give folder to user Pi
chmod 770 /usr/bin/backupmypi
chmod +x /bin/backup
chmod +x /usr/bin/backupmypi/*
echo "cleanup"
rm /usr/bin/backupmypi/update.notes
echo "finish."
if [ msg_config_created = "true" ]; then
	echo "Config file has been freshly created, please check!"
fi
