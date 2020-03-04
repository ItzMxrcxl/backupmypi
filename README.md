
# BackupMyPi

## Was ist BackupMyPi?
BackupMyPi ist ein Gratis Tool um während dem Betrieb ein volles Backup deiner SD-Karte zu erstellen.
BackupMyPi erlaubt dir, ein komplettes Image deiner SD Karte des Raspberry Pi's oder auch Linux System zu erstellen, mit nur einem Befehl.
## Wie installiere ich BackupMyPi?
Das ist ganz einfach.
Zuerst verbindest du dich pre SSH mit deinem Pi (Desktop Shell geht auch). Danach ladest du dir die Git Repo herunter.

    git clone https://github.com/ItzMxrcxl/backupmypi.git
Nachdem es sich geklont hat, müssen wir in den Ordner gehen.

    cd backupmypi

Anschliessend müssen wir den Installer ausführbar machen. Das machen wir mit dem folgenden Befehl.

    sudo chmod +x install.sh
zum Schluss führen wir die Datei aus. **Diesen müssen wir mit "sudo" Rechten ausführen.**

    sudo bash install.sh
Nachdem der Installer erfolgreich ausgeführt wurde müssen wir die Konfiguration anpassen. Standardmässig werden die backups
 

## Backup Ordner einhängen
Das Tool installiert bei der Installation alle benötigten Pakete.
### Wie Mounte ich ein Datenträger?

Zuerst suchen wir den "Buchstaben" des Datenträgers. 
Im Normalfall, wenn man einen Datenträger (USB-Stick) am Raspberry Pi eingesteckt hat, wird zu 99% der "Buchstabe" /dev/sda1 vergeben.
Zur Überprüfung geben wir folgendes ein.

    fdisk -l 2>/dev/null | grep "Disk \/" | grep -v "\/dev\/md" | awk '{print $2}' | sed -e 's/://g'
Mit diesem Befehl werden alle Datenträger angezeigt.
Hier sollte dieser nun auftauchen. Um den Namen des Datenträgers anzuzeigen, gibt man folgenden Befehl ein.

    blkid

Um diesen nun zu Mounten geht man wie folgt vor.

Um den Datenträger "Temporär" (nach einem neustart nicht mehr verfügbar) zu Mounten gibt man folgenden Befehl ein. Bei einem anderen Format als exfat muss exfat mit demjenigen Format ersetzt werden das gewünscht ist.

    mount -t exfat /dev/*** /mnt/backup
*Die Sternchen mit dem "Laufwerksbuchstaben" ersetzen* 
Um den Datenträger Permanent zu Mounten muss man einen Eintrag im fstab erstellen. Es wird dann empfohlen, den USB Stick eingesteckt zu lassen.

    sudo nano /etc/fstab
In der Datei geht man mit den Pfeiltasten ganz nach unten und fügt folgende Zeile ein.
```
/dev/*** /mnt/backup exfat-fuse defaults 0 0
```
*Die Sternchen mit dem "Laufwerksbuchstaben" ersetzen* 
nachdem man dies eingetragen hat, drückt man CTRL+O um zu Speichern und CTRL+X um nano zu schliessen.
um den Datenträger nun einzuhängen gibt man den Befehl

    sudo mount -a
ein.

Um nun zu überprüfen ob dieser auch korrekt eingehängt wurde, gibt man zum schluss noch dem Befehl

    sudo df -h
ein.

Das war das einhängen.

Standardmässig erstellt das Script keinen Backup Ordner, somit müssen wir diesen noch erstellen.

    sudo mkdir /mnt/backup/PiBackup

#### Fehlerbehebung exFat
Wenn nun der Fehler...

> FUSE exfat 1.0.1 
> WARN: volume was not unmounted cleanly.

...beim Mounten erscheint, gibt man folgenden Befehl zu der Lösung ein.

    fsck.exfat /dev/***
*Die Sternchen mit dem "Laufwerksbuchstaben" ersetzen*
### Wie Mounte ich ein Windows Share?
	[Mount Permanent](https://wiki.ubuntu.com/MountWindowsSharesPermanently)
	[Samba Cifs Client](https://wiki.ubuntuusers.de/Samba_Client_cifs/)
## Fehlerbehandlung

> ERROR: Backup folder: xxxxx : doesnt exist, is the backup medium mounted? Try mounting the medium/share or create the backup folder.

Zuerst überprüft man ob der Datenträger auf den das Backup geladen wird, eingehängt ist. Dies macht man mit dem Befehl

    sudo df -h | grep /dev/***
Wobei hier die Sternchen den "Laufwerksbuchstaben" ersetzen.
Wenn dies nicht der fall ist gehe zu "Wie Mounte ich ein Datenträger?"
Wenn der Datenträger in diese Liste angezeigt wird, überprüfe ob der Pfad der in der config.txt eingetragen ist, auf dem Backup Datenträger existiert.
Wenn der Ordner nicht existiert, erstelle diesen mit dem Befehl

    sudo mkdir [Pfad]
