#!/bin/bash

# Created: 2024/08/07
# Last modified: 2024/08/07
# Copy data from Raspberry Pi SD card to local

red=$'\e[1;31m'
grn=$'\e[1;32m'
end=$'\e[0m'

date=$(date -I)
local_of="/Users/$1/pi-data/backups/$2/$date.img.gz"

exit_process() {
    echo "[${red}EXIT${end}] Killing script..."
    exit 1
}

trap exit_process INT TERM

if [[ $# -ne 2 ]]; then
    echo "[${red}ERROR${end}] USAGE: $0 <Mac username> <device name>"
    exit_process
fi

# Make directory if it does not exist
mkdir -p "$(dirname "$local_of")"

# Copy locally
if [ ! -e "$local_of" ]; then
    echo "[${grn}INFO${end}] Copying and compressing $2 SD card to $local_of"
    sudo dd bs=4m if=/dev/rdisk4 status=progress conv=fsync | gzip > "$local_of"
else 
    echo "[${grn}INFO${end}] Local file $local_of exists. Skipping copy..."
fi

echo "[${grn}INFO${end}] Backup of $2 complete"
