#!/bin/bash

# Created: 2021/07/23 06:46:33
# Last modified: 2021/07/23 08:10:24

red=$'\e[1;31m'
grn=$'\e[1;32m'
end=$'\e[0m'

exit_process() {
    echo "[${red}EXIT${end}] Killing script..."
    exit 1
}

trap exit_process INT TERM

echo "[${grn}INFO${end}] Writing to SD card..."
unzip -p 2020-12-02-raspios-buster-armhf-full.zip | sudo dd of=/dev/mmcblk0 bs=4M status=progress conv=fsync

echo "[${grn}INFO${end}] SD card partitions..."
sudo fdisk -l /dev/mmcblk