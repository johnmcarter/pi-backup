#!/bin/bash

# Created: 2021/07/23 07:26:18
# Last modified: 2021/07/23 08:09:32
# Copy data from Raspberry Pi SD card to local directory

red=$'\e[1;31m'
grn=$'\e[1;32m'
end=$'\e[0m'

date=$(date -I)

exit_process() {
    echo "[${red}EXIT${end}] Killing script..."
    exit 1
}

trap exit_process INT TERM

if [[ $# -ne 1 ]]; then
    echo "[${red}ERROR${end}] USAGE: $0 <device name>"
    exit_process
fi

echo "[${grn}INFO${end}] Copying and compressing $1 SD card..."

sudo dd bs=4M if=/dev/mmcblk0 status=progress conv=fsync | gzip > /home/birch/pi_data/backups/$1-$date.img.gz

echo "[${grn}INFO${end}] Success"