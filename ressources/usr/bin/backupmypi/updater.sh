#!/bin/bash
# Author: Marcel Kallinger https://github.com/ItzMxrcxl
# Part of the Open Source BackupMyPi Script
# Automatic Update Script
echo "~~~~~~~~~~~~~~~~BackupMyPi - Updater~~~~~~~~~~~~~~~~"
echo "Author: Marcel Kallinger"
echo "https://github.com/ItzMxrcxl"
echo ""

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
while [ -n "$1" ]; do

	case "$1" in
	-force) force_update ;;

	 ) self_update ;;
	esac

	shift
done
exit 0