#!/bin/bash
# Author: Marcel Kallinger https://github.com/ItzMxrcxl
# Part of the BackupMyPi Project
# Automatic Update Script
echo "~~~~~~~~~~~~~~~~BackupMyPi - Updater~~~~~~~~~~~~~~~~"
echo "Author: Marcel Kallinger"
echo "https://github.com/ItzMxrcxl"
echo ""

check_connection() {
	echo "Check connection"
	wget -q --spider github.com
	if [ $? -eq 0 ]; then
		echo "OK"
	else
		echo "could not estabalise a Connection"
		exit 50
	fi
	exit 0
}

self_update() {
	if [[ ! -d /usr/bin/backupmypi/temp ]]; then
		echo "Temp directory doesn't exist"
		mkdir /usr/bin/backupmypi/temp
	fi
	cd /usr/bin/backupmypi/temp
	GITHUB_VERSION=`curl --silent -H 'Cache-Control: no-cache' -o - https://raw.githubusercontent.com/ItzMxrcxl/backupmypi/master/ressources/usr/bin/backupmypi/version`
	LOCAL_VERSION=`cat /usr/bin/backupmypi/version`
	
	if [[ ! $GITHUB_VERSION = $LOCAL_VERSION ]]; then
		echo 'Found updates for the Script. Github Version' $GITHUB_VERSION 'Local Version' $LOCAL_VERSION
		git clone https://github.com/ItzMxrcxl/backupmypi.git
		echo "Start install new Version..."
		cd backupmypi
		chmod +x install.sh
		sudo bash install.sh
		cd ..
		sudo rm -r /usr/bin/backupmypi/temp
		exit 0
	else
		echo "Script up to date."
	fi
}

force_update() {
	if [[ ! -d /usr/bin/backupmypi/temp ]]; then
		echo "Temp directory doesn't exist"
		mkdir /usr/bin/backupmypi/temp
	fi
	cd /usr/bin/backupmypi/temp
	GITHUB_VERSION=`curl --silent -H 'Cache-Control: no-cache' -o - https://raw.githubusercontent.com/ItzMxrcxl/backupmypi/master/ressources/usr/bin/backupmypi/version`
	echo 'update the Script to (Github Version) ' $GITHUB_VERSION
	git clone https://github.com/ItzMxrcxl/backupmypi.git
	echo "Start install new Version..."
	cd backupmypi
	chmod +x install.sh
	sudo bash install.sh
	cd ..
	sudo rm -r /usr/bin/backupmypi/temp
	exit 0
}

check_connection

if [ -z $1 ] #if no argument is given set arg normal (*)
then
  arg="normal"
elif [ -n $1 ]
then #otherwise arg=argument
  arg=$1
fi

case "$arg" in
	-force) force_update ;;
	-update) self_update ;;
	*) self_update ;;
esac
exit 0