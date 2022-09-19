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

# generate filesystem
mkfs.btrfs -L root /dev/$root # create btrfs filesystem with label 'root'
mkswap -L swap /dev/$swap # create swap with label 'swap'
# no efi for windows?

# btrfs filesystem
mount /dev/$root /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home

umount /mnt
mount -o subvol=@ /dev/$root /mnt
mkdir -p /mnt/home
mount -o subvol=@home /dev/root /mnt/home

mount --mkdir /dev/$efi /mnt/boot
swapon /dev/$swap

# installation of basic arch linux software
pacstrap /mnt base linux linux-firmware base-devel man-db neovim networkmanager

cd

genfstab -L /mnt >> /mnt/etc/fstab
#arch-chroot /mnt
ln -sf mnt/usr/share/zoneinfo/Europe/Brussels mnt/etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> mnt/etc/locale.gen
arch-chroot /mnt /bin/bash -c "locale-gen"

touch /etc/locale.conf
echo "LANG=en_US.UTF-8" >> mnt/etc/locale.conf

touch /etc/vconsole.conf
echo "KEYMAP=azerty" >> mnt/etc/vconsole.conf

touch /etc/hostname
echo "thinkbook" >> mnt/etc/hostname

mkinitcpio -P

arch-chroot /mnt /bin/bash -c "passwd"

# boot loader?
