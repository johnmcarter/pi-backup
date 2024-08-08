#!/bin/bash

# Created: 2024/08/07
# Last modified: 2024/08/07
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

# Find the disk number for the SD card
diskutil list
echo "[${grn}INFO${end}] Please enter the disk identifier for the SD card (e.g., disk4):"
read disk_id

if [[ -z "$disk_id" ]]; then
    echo "[${red}ERROR${end}] No disk identifier entered. Exiting."
    exit_process
fi

disk_device="/dev/$disk_id"
rdisk_device="/dev/r$disk_id"

# Unmount the disk
echo "[${grn}INFO${end}] Unmounting $disk_device..."
diskutil unmountDisk "$disk_device"

if [[ $? -ne 0 ]]; then
    echo "[${red}ERROR${end}] Failed to unmount $disk_device. Exiting."
    exit_process
fi

echo "[${grn}INFO${end}] Writing $1 to SD card $rdisk_device..."
gunzip -c "$1" | sudo dd of="$rdisk_device" bs=4m status=progress conv=fsync

if [[ $? -ne 0 ]]; then
    echo "[${red}ERROR${end}] Failed to write $1 to $rdisk_device."
    exit_process
fi

echo "[${grn}INFO${end}] File $1 successfully written"

echo "[${grn}INFO${end}] SD card partitions..."
diskutil list "$disk_device"
