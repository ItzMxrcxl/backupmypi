#!/bin/bash
# Author: Marcel Kallinger https://github.com/ItzMxrcxl
# Part of the Open Source BackupMyPi Script
# Automatic Update Script

self_update() {
	if [[ ! /usr/bin/backupmypi/temp ]]; then
		mkdir /usr/bin/backupmypi/temp
	fi
    cd /usr/bin/backupmypi/temp
	echo "Checking version files..."
    GITHUB_VERSION=`curl -o - https://raw.githubusercontent.com/ItzMxrcxl/backupmypi/master/ressources/usr/bin/backupmypi/version`
	LOCAL_VERSION=`cat /usr/bin/backupmypi/version`
	
    if [[ ! GITHUB_VERSION = LOCAL_VERSION ]]; then
        echo "Found updates for the Script..."
        git clone https://github.com/ItzMxrcxl/backupmypi.git
        echo "Start install new Version..."
		cd backupmypi
		chmod +x install.sh
        exec install.sh
        exit 100
	else
		echo "Script up to date."
	fi
}
self_update