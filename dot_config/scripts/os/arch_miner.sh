# Remember to install Windows with custom ESP size to make dualboot easy
# https://www.ctrl.blog/entry/how-to-esp-windows-setup.html

gdisk /dev/nvme0nX

mkfs.fat -F 32 /dev/nvme0nXp1
mkfs.f2fs /dev/nvme0nXp3

mount /dev/nvme0nXp3 /mnt
mount /dev/nvme0nXp1 /mnt/boot --mkdir

# /etc/pacman.conf
ParallelDownloads = 3

# If NVIDIA GPU add "nvidia"
pacstrap -K /mnt base base-devel linux linux-firmware amd-ucode nano sudo tmux wget git

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
usermod -s /bin/sh u
usermod -s /bin/sh root
passwd u
passwd

pacman -S dropbear dhcpcd cronie iwd
systemctl enable dropbear
systemctl enable dhcpcd
systemctl enable cronie
systemctl enable iwd

# efiboot
pacman -S efibootmgr
efibootmgr --create --disk /dev/nvme0n1 --part 1 --label "Arch Linux" \
--loader /vmlinuz-linux --unicode 'root=/dev/nvme0n1p2 rw
quiet nowatchdog nmi_watchdog=0 mitigations=off loglevel=0 rd.udev.log_level=0 \
intel_idle.max_cstate=1 cryptomgr.notests initcall_debug intel_iommu=igfx_off \
no_timer_check noreplace-smp page_alloc.shuffle=1 rcupdate.rcu_expedited=1 tsc=reliable
initrd=\amd-ucode.img initrd=\initramfs-linux.img'

# systemd-boot (for dualboot with Windows)
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

exit
umount -R /mnt
reboot

git clone --depth=1 https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si
cd ..
rm -rf paru-bin

paru -S --noconfirm alhp-keyring alhp-mirrorlist

# /etc/pacman.conf
[core-x86-64-v4]
Include = /etc/pacman.d/alhp-mirrorlist

[extra-x86-64-v4]
Include = /etc/pacman.d/alhp-mirrorlist

sudo pacman -Syu
reboot
