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
. /usr/bin/backupmypi/config.txt # Load Config

DATE=$(date '+%Y-%m-%d_%H-%M-%S')

self_update() {
	echo "Prüfe updates..."
	cd /usr/bin/backupmypi/
	sudo bash updater.sh
	if [ ! $? -eq 0 ]; then
		echo "Error! "$?
	fi
}

main() (
	sudo mount $backup_mount_path
	backup
)

backup() (
	DATE_STARTED=$(date '+%Y-%m-%d_%H-%M-%S')
	BOOT=$backup_drive
	test -e $BOOT
	if [ ! $?=0 ]; then
		echo "Backup Quelle "$BOOT" exisitert nicht! Bitte überprüfe Konfig Datei"
		exit 1
	fi

	if [[ ! -d $backup_path ]]; then
		echo "ERROR: Backup Ordner "$backup_path" exisitert nicht, Ist das Speichergerät mounted? Existiert der Ordner auf dem Gerät?"
		exit 1
	fi
	
	a=$SECONDS #Start the timer
	backup_file=$backup_path'/'$backup_name'.img'

	if [ $shrink_image = 'True' ]; then
		if [ $compress_image = 'True' ]; then
			echo "Erstelle Backup von "$BOOT", dies wird nach dem Kopieren verkleinert und gepackt."
			normal_backup
			just_shrink
		else
			echo "Erstelle Backup von "$BOOT", speichere dies unter "$backup_file" , dies wird nach dem Kopieren verkleinert"
			normal_backup
			just_shrink
		fi
	else
		echo "Erstelle Backup von "$BOOT", speichere dies unter "$backup_file".gz"
		if [ $compress_image = 'True' ]; then
			zip_copy
		fi
	fi
)

zip_copy() ( #Shrinking image while copying
	echo "Backupdatei wird wärend dem Backup zusätzlich gepackt."
	sudo dd if=$BOOT conv=sparse bs=512 status=progress | gzip -c  > $backup_file'.gz'
)

normal_backup() (
	sudo dd if=$BOOT of=$backup_file conv=sparse bs=512 status=progress
)

just_shrink() (
	echo "Verkleinere Image"
	sudo pishrink $backup_file
)

just_zip() (
	gzip $backup_file $backup_file'.gz'
	rm $backup_file
)

output() (
	duration=$SECONDS #Stop the timer
	echo "Das Backup wurde in $(($duration / 60)) Minuten und $(($duration % 60)) Sekunden erstellt." #Output the Timer

	if [ unmount_after_backup = 'True' ]; then
	echo "Hänge Backup drive "$backup_mount_path" aus"
		umount $backup_mount_path
	fi
)

self_update #If you want to disable the Autoupdate, mark this line
main
output