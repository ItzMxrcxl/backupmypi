#!/bin/bash
# Author: Marcel Kallinger https://github.com/ItzMxrcxl
# Open Source BackupMyPi Script

. /usr/bin/backupmypi/config.txt

DATE=$(date '+%Y-%m-%d_%H-%M-%S')

#For logging
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
touch /tmp/bmp_$DATE.log
exec 1>/tmp/bmp_$DATE.log 2>&1

self_update() {
	if [[ ! -d /usr/bin/backupmypi/temp ]]; then
		echo "Temp directory doesn't exist"
		mkdir /usr/bin/backupmypi/temp
	fi
    cd /usr/bin/backupmypi/temp
    GITHUB_VERSION=`curl -o - https://raw.githubusercontent.com/ItzMxrcxl/backupmypi/master/ressources/usr/bin/backupmypi/version`
	LOCAL_VERSION=`cat /usr/bin/backupmypi/version`
	
    if [[ ! $GITHUB_VERSION = $LOCAL_VERSION ]]; then
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

main() ( #if you wana build a part in it, before the backup wil be executed.
	backup
)
backup() (
	DATE_STARTED=$(date '+%Y-%m-%d_%H-%M-%S')
	a=$SECONDS #Start the second timer
	echo "Started backup at " + $DATE_STARTED
	backup_file=$backup_path + "/" + $DATE_STARTED + ".img" #the filename
	BOOT=`awk '$2 == "/"' /proc/self/mounts | sed 's/\s.*$//'`
	echo "Create backup from device $BOOT"
	dd if=$BOOT of=$backup_file status=progress
	if $shrink_image = True ; then
		shrink
	fi
)

shrink() ( #Shrinking the image file to a realisable filesize
	echo "Zipping backup file to shrink filesize"
	BACKUP_USEDSPACE=$`du --apparent-size $backup_file`
	gzip $backup_file
	
)

output() (
	duration=$SECONDS #Stop the timer
	echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed." #Output the Timer
)


self_update #If you want to disable the Autoupdate, mark this line
main
output