#!/bin/bash

echo "welcome to the install_arch.sh script created by Mathias"

# basic setup 
loadkeys azerty # load azerty keys to keyboard
timedatectl set-ntp true 
lsblk #display all block devices


# configuration drive (partitions)
echo -n "Enter drive:"
read drive
echo $drive

changes="n"

# 
while [ $changes != "y" ];
do
	echo "Partitions from drive $drive are:"
	lsblk "/dev/"$drive

	cfdisk "/dev/"$drive

	echo "are the partitions OK for drive $drive (y/n): "
	read changes
done

echo "select the root partition, efi partition and swap partition"
echo -n "root partition:"
read root
echo -n "efi partition:"
read efi
echo -n "swap partition:"
read swap

#fdisk $drive << FDISK_CMD

#FDISK_CMD
