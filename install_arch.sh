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
mkfs.fat -F 32 /dev/$efi
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
# + additional (basic) software
# text editor: Neovim
# networking: NetworkManager
pacstrap /mnt base linux linux-firmware base-devel man-db neovim networkmanager grub efibootmgr btrfs-progs

cd

genfstab -L /mnt >> /mnt/etc/fstab
#arch-chroot /mnt
ln -sf /mnt/usr/share/zoneinfo/Europe/Brussels /mnt/etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen
arch-chroot /mnt /bin/bash -c "locale-gen"

touch /mnt/etc/locale.conf
echo "LANG=en_US.UTF-8" >> /mnt/etc/locale.conf

touch /mnt/etc/vconsole.conf
echo "KEYMAP=azerty" >> /mnt/etc/vconsole.conf

touch /mnt/etc/hostname
echo "thinkbook" >> /mnt/etc/hostname

arch-chroot /mnt /bin/bash -c "mkinitcpio -P"

arch-chroot /mnt /bin/bash -c "passwd"

arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager"


# boot loader
#arch-chroot /mnt /bin/bash -c "refind-install"
#mkdir -p /mnt/boot/EFI/refind/drivers/x64
#cp /mnt/usr/share/refind/drivers_x64/btrfs_x64.efi /mnt/boot/EFI/refind/drivers_x64/btrfs_x64.efi

#touch /mnt/boot/refind_linux.conf
#echo "also_scan_dirs +,@/boot" >> /mnt/boot/EFI/refind/refind.conf
#echo \"Boot using standard options\"  \"root=PARTUUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX rw rootflags=subvol=@ initrd=subvolume\\boot\\initramfs-%v.img\" >> /mnt/boot/refind_linux.conf

# grub

grub-install --targer=x86_64-efi --efi-directory=/dev/$efi --bootloader-id=GRUB
grub-mkconfig -o mnt/boot/grub/grub.cfg
