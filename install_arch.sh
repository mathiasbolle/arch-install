#!/bin/bash

echo "welcome to the install_arch.sh script created by Mathias"

loadkeys azerty # load azerty keys to keyboard
timedatectl set-ntp true 
lsblk #display all block devices
echo -n "Enter drive:"
read drive
echo $drive

echo "Partitions from drive $drive are:"
lsblk $drive

echo -n "root partition:"
read root
echo -n "efi partition:"
read efi


#fdisk $drive << FDISK_CMD

#FDISK_CMD
