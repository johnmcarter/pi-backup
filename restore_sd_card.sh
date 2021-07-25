#!/bin/bash

# Created: 2021/07/23 06:46:33
# Last modified: 2021/07/24 22:49:08
# Write a zipped image to an SD card

red=$'\e[1;31m'
grn=$'\e[1;32m'
end=$'\e[0m'

exit_process() {
    echo "[${red}EXIT${end}] Killing script..."
    exit 1
}

trap exit_process INT TERM

if [[ $# -ne 1 ]]; then
    echo "[${red}ERROR${end}] USAGE: $0 <zipped image file>"
    exit_process
fi

echo "[${grn}INFO${end}] Writing $1 to SD card..."
gunzip $1 | sudo dd of=/dev/mmcblk0 bs=4M status=progress conv=fsync
echo "[${grn}INFO${end}] File $1 successfully written"

echo "[${grn}INFO${end}] SD card partitions..."
sudo fdisk -l /dev/mmcblk