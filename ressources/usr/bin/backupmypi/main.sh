#!/bin/bash
# Author: Marcel Kallinger https://github.com/ItzMxrcxl
# BackupMyPi Script
echo "~~~~~~~~~~~~~~~BackupMyPi - Backup~~~~~~~~~~~~~~~~"
echo "Author: Marcel Kallinger"
echo "https://github.com/ItzMxrcxl"
echo ""

if [[ ! -f "/usr/bin/backupmypi/config.txt" ]]
then
		echo "ERROR: Config Datei existiert nicht"
		exit 2
fi
. /usr/bin/backupmypi/config.txt

DATE=$(date '+%Y-%m-%d_%H-%M-%S')

#For logging
# exec 3>&1 4>&2
# trap 'exec 2>&4 1>&3' 0 1 2 3
# touch /tmp/bmp_$DATE.log
# exec 1>/tmp/bmp_$DATE.log 2>&1

self_update() {
	echo "Prüfe updates..."
	cd /usr/bin/backupmypi/
	sudo bash updater.sh
	if [ ! $? -eq 0 ]; then
		echo "Error! "$?
	fi
}

main() ( #if you wana build a part in it, before the backup wil be executed.
	backup
)

backup() (
	DATE_STARTED=$(date '+%Y-%m-%d_%H-%M-%S')
	BOOT=$backup_drive
	if [[ ! -d $backup_path ]]; then
		echo "ERROR: Backup Ordner "$backup_path" exisitert nicht, Ist das Speichergerät mounted?"
		exit 1
	fi
	test -e $BOOT
	if [ ! $?=0 ]; then
		echo "Backup Quelle "$BOOT" exisitert nicht! Bitte überprüfe Konfig Datei"
		exit 1
	fi
	a=$SECONDS #Start the timer
	backup_file=$backup_path'/'$DATE_STARTED'.img' #the filename
	#BOOT=`awk '$2 == "/"' /proc/self/mounts | sed 's/\s.*$//'` #Get boot device with partition
	if [ $compress_image = 'True' ]; then
		echo "Erstelle Backup von " $BOOT", speichere dies unter "$backup_file".gz"
		zip
	else
		echo "Erstelle Backup von " $BOOT", speichere dies unter "$backup_file
		normal_backup
	fi
)

zip() ( #Shrinking image while copying
	echo "Backupdatei wird wärend dem Backup zusätzlich gepackt."
	sudo dd if=$BOOT conv=sparse bs=4M status=progress | gzip -c  > $backup_file'.gz'
)
normal_backup() (
	sudo dd if=$BOOT of=$backup_file conv=sparse bs=4M status=progress
)

output() (
	duration=$SECONDS #Stop the timer
	echo "Das Backup wurde in $(($duration / 60)) Minuten und $(($duration % 60)) Sekunden erstellt." #Output the Timer
)

self_update #If you want to disable the Autoupdate, mark this line
main
output