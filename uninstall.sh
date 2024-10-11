#!/bin/bash

clear
if [ "${EUID}" -ne 0 ]; then
    red='\033[0;31m'
    reset='\033[0m'
    echo -e "${red}You need to run this script as root!${reset}"
    exit 1
fi

swapfile="/swapfile"

if [ -e "$swapfile" ]; then
    swapoff "$swapfile" >/dev/null 2>&1
    rm -f "$swapfile"
    
    if grep -q "$swapfile" /etc/fstab; then
        sed -i "\|$swapfile|d" /etc/fstab
    fi
    
    green='\033[0;32m'
    reset='\033[0m'
    echo -e "${green}Swap RAM uninstalled successfully.${reset}"
else
    red='\033[0;31m'
    reset='\033[0m'
    echo -e "${red}Swap RAM does not exist.${reset}"
fi