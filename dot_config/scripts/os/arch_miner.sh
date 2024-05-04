gdisk /dev/nvme0nX

mkfs.fat -F 32 /dev/nvme0nXp1
mkfs.f2fs /dev/nvme0nXp3

mount /dev/nvme0nXp3 /mnt
mount /dev/nvme0nXp1 /mnt/boot --mkdir

# /etc/pacman.conf
ParallelDownloads = 3

pacstrap -K /mnt amd-ucode sof-firmware base linux linux-firmware nvidia nano sudo

# /mnt/etc/mkinitcpio.conf
MODULES=(nvme nvme_core f2fs)
HOOKS=(base autodetect microcode modconf kms)

# /mnt/etc/mkinitcpio.d/linux.preset
PRESETS=('default')

genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc

# /etc/locale.gen
en_US.UTF-8 UTF-8

locale-gen

# /etc/locale.conf
LANG=en_US.UTF-8

# /etc/hostname
miner$NUMBER

# /etc/pacman.conf
ParallelDownloads = 3

# /etc/sudoers
%wheel ALL=(ALL:ALL) NOPASSWD: ALL

useradd -mG wheel u
usermod -s /bin/sh root
passwd u
passwd

pacman -S networkmanager openssh
systemctl enable NetworkManager
systemctl enable sshd

bootctl install

# /boot/loader/loader.conf
default arch.conf
timeout 3  # 0 if not Windows installed
console-mode keep
editor no

# /boot/loader/entries/arch.conf
title Arch Linux
linux /vmlinuz-linux
initrd /amd-ucode.img
initrd /initramfs-linux.img
options \
	root=/dev/nvme0nXp3
	rw quiet nmi_watchdog=0 mitigations=off systemd.show_status=false \
	rd.udev.log_level=0 vt.global_cursor_default=0
