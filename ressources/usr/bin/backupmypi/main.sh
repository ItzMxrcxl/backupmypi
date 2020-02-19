#!/bin/bash
# Author: Marcel Kallinger https://github.com/ItzMxrcxl
# Open Source BackupMyPi Script

VERSION="1.0"
. /usr/bin/backupmypi/config.txt

SCRIPT="backupmypi"
SCRIPTPATH="/usr/bin/backupmypi/temp"
SCRIPTNAME="install.sh"
ARGS="$@"
BRANCH="ItzMxrcxl"

DATE=$(date '+%Y-%m-%d_%H-%M-%S')

#For logging
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>/tmp/bmp_$DATE.log 2>&1

self_update() {
    cd $SCRIPTPATH
    git fetch

    [ -n $(git diff --name-only origin/$BRANCH | grep $SCRIPTNAME) ] && {
        echo "Found updates for the Script..."
		mkdir $SCRIPTPATH
        git pull --force
        git checkout $BRANCH
        git pull --force
        echo "Start install new Version..."
        exec "$SCRIPTNAME" "$@"
        exit 100
    }
    echo "Script up to date."
}

main() ( #if you wana build a part in it, before the backup wil be executed.
	backup
)
backup() (
	DATE_STARTED=$(date '+%Y-%m-%d_%H-%M-%S')
	a=$SECONDS #Start the second timer
	echo "Started backup at " + $DATE_STARTED
	backup_file=$backup_path + "/" + $DATE_STARTED + ".img" #the filename
	
	dd if=/dev/mmcblk0 of=$backup_file status=progress
	if $shrink = False ; then
		shrink
	fi
)

shrink() ( #Shrinking the image file to a realisable filesize
	echo "Zipping backup file to shrink filesize"
	gzip $backup_file
	
)

output() (
	duration=$SECONDS #Stop the timer
	echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed." #Output the Timer
)


self_update #If you want to disable the Autoupdate, mark this line
main
output