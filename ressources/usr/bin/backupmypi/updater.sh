#!/bin/bash
# Author: Marcel Kallinger https://github.com/ItzMxrcxl
# Part of the Open Source BackupMyPi Script
# Automatic Update Script
echo "~~~~~~~~~~~~~~~~BackupMyPi~~~~~~~~~~~~~~~~"
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
        echo "Found updates for the Script..."
        git clone https://github.com/ItzMxrcxl/backupmypi.git
        echo "Start install new Version..."
		cd backupmypi
		chmod +x install.sh
        sudo bash install.sh
		cd ..
		sudo rm -r /usr/bin/backupmypi/temp
        exit 100
	else
		echo "Script up to date."
	fi
}
self_update