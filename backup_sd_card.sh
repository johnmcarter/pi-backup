#!/bin/bash

# Created: 2021/07/23 07:26:18
# Last modified: 2021/07/23 09:32:29
# Copy data from Raspberry Pi SD card 
# to local machine and backup disk

red=$'\e[1;31m'
grn=$'\e[1;32m'
end=$'\e[0m'

date=$(date -I)
local_of="/home/birch/pi_data/backups/$1/$date.img.gz"
disk_of="/media/birch/Seagate Backup Plus Drive/backups/$1/$date.img.gz"
disk_dir="/media/birch/Seagate Backup Plus Drive/backups/$1/"

exit_process() {
    echo "[${red}EXIT${end}] Killing script..."
    exit 1
}

trap exit_process INT TERM

if [[ $# -ne 1 ]]; then
    echo "[${red}ERROR${end}] USAGE: $0 <device name>"
    exit_process
fi

# copy locally 
if [ ! -e "$local_of" ]; then
    echo "[${grn}INFO${end}] Copying and compressing $1 SD card to $local_of"
    sudo dd bs=4M if=/dev/mmcblk0 status=progress conv=fsync | gzip > $local_of
else 
    echo "[${grn}INFO${end}] Local file $local_of exists. Skipping copy..."
fi

# copy to backup drive
if [ ! -e "$disk_of" ]; then
    echo "[${grn}INFO${end}] Copying $local_of to $disk_dir"
    cp "$local_of" "$disk_dir"
else 
    echo "[${grn}INFO${end}] Disk file $disk_of exists. Skipping copy..."
fi

echo "[${grn}INFO${end}] Backup of $1 complete"