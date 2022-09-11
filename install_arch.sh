#!/bin/bash

echo "welcome to the install_arch.sh script created by Mathias"

loadkeys azerty # load azerty keys to keyboard
timedatectl set-ntp true 
lsblk #display all block devices
echo -n "Enter drive:"
read drive
echo $drive

