#!/bin/bash
# Author: Marcel Kallinger https://github.com/ItzMxrcxl
# BackupMyPi Script

. /usr/bin/backupmypi/config.txt

DATE=$(date '+%Y-%m-%d_%H-%M-%S')

#For logging
# exec 3>&1 4>&2
# trap 'exec 2>&4 1>&3' 0 1 2 3
# touch /tmp/bmp_$DATE.log
# exec 1>/tmp/bmp_$DATE.log 2>&1

self_update() {
	cd /usr/bin/backupmypi/
	sudo bash updater.sh
}

main() ( #if you wana build a part in it, before the backup wil be executed.
	backup
)
backup() (
	DATE_STARTED=$(date '+%Y-%m-%d_%H-%M-%S')
	a=$SECONDS #Start the second timer
	if [[ ! -d $backup_path ]]; then
		echo "ERROR: Backup folder: "$backup_path" : doesnt exist, is the backup medium mounted? Try mounting the medium/share or create the backup folder."
		exit 1
	fi
	echo "Started backup at " $DATE_STARTED
	backup_file=$backup_path'/'$DATE_STARTED'.img' #the filename
	BOOT=`awk '$2 == "/"' /proc/self/mounts | sed 's/\s.*$//'`
	BOOT='/dev/mmcblk0' #for raspi
	echo "Create backup from device " $BOOT
	sudo dd if=$BOOT of=$backup_file status=progress
	if [ $shrink_image = 'True' ]; then #if shrink_image is in Config file True, execute shrink
		shrink
	fi
)

shrink() ( #Shrinking the image file to a realisable filesize
	echo "Zipping backup file to shrink filesize, unpacked file will be same big as the SD-Card!"
	 pv $backup_file | gzip > $backup_file'.gz'
)

output() (
	duration=$SECONDS #Stop the timer
	echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed." #Output the Timer
)


self_update #If you want to disable the Autoupdate, mark this line
main
output