#!/bin/bash

clear
if [ "${EUID}" -ne 0 ]; then
    red='\033[0;31m'
    reset='\033[0m'
    echo -e "${red}You need to run this script as root!${reset}"
    exit 1
fi

swapfile="/swapfile"
bs=2048
count=1048576

if [ -e "$swapfile" ]; then
    swapoff "$swapfile" >/dev/null 2>&1
    rm -f "$swapfile"
fi

dd if=/dev/zero of="$swapfile" bs=$bs count=$count
mkswap "$swapfile"
chown root:root "$swapfile"
chmod 0600 "$swapfile"
swapon "$swapfile" >/dev/null 2>&1

if ! grep -q "$swapfile" /etc/fstab; then
    echo "$swapfile      swap swap   defaults    0 0" >> /etc/fstab
fi

green='\033[0;32m'
reset='\033[0m'
echo -e "${green}Swap RAM 2GB installed successfully.${reset}"