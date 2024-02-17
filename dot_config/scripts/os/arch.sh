loadkeys br-abnt2
setfont ter-132b
iwctl station wlan0 connect $SSID

gdisk /dev/nvme0nX
# 512 MB - EFI (ef00)
# 8 GB - SWAP (8200)
# Free space - Root (8304)

mkfs.fat -F 32 /dev/nvme0nXp1
mkswap /dev/nvme0nXp2
mkfs.ext4 /dev/nvme0nXp3

mount /dev/nvme0nXp3 /mnt
mount /dev/nvme0nXp1 /mnt/boot --mkdir
swapon /dev/nvme0nXp2

# /etc/pacman.conf
ParallelDownloads = 3

pacstrap -K /mnt intel-ucode sof-firmware base base-devel linux-zen linux-zen-headers linux-firmware git nano sudo ttf-liberation less
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc

# /etc/locale.gen
en_US.UTF-8 UTF-8

# Generate locales
locale-gen

# /etc/locale.conf
LANG=en_US.UTF-8

# /etc/vconsole.conf
KEYMAP=br-abnt2

# /etc/hostname
note

# /etc/pacman.conf
ParallelDownloads = 3

# /etc/sudoers
%wheel ALL=(ALL:ALL) NOPASSWD: ALL

useradd -mG wheel u
passwd u
passwd
usermod -s /bin/sh root

pacman -S iwd dhcpcd tlp bluez bluez-utils pulseaudio pulseaudio-bluetooth
systemctl enable iwd
systemctl enable tlp
systemctl enable dhcpcd
systemctl enable bluetooth

bootctl install

# /boot/loader/loader.conf
default arch.conf
timeout 0
console-mode keep
editor no

# /boot/loader/entries/arch.conf
title Arch Linux
linux /vmlinuz-linux-zen
initrd /intel-ucode.img
initrd /initramfs-linux-zen.img
options root=/dev/nvme0nXp3 resume=/dev/nvme0nXp2 rw quiet nmi_watchdog=0 mitigations=off systemd.show_status=false rd.udev.log_level=0 vt.global_cursor_default=0 i915.fastboot=1

# If using Sway
pacman -S sway swaybg foot fuzzel kanshi xorg-xwayland

# If using KDE
pacman -S plasma-desktop plasma-wayland-session plasma5-applets-window-buttons kscreen kcalc konsole dolphin spectacle okular kate

# Essential packages
pacman -S chezmoi pulsemixer discord telegram-desktop sqlitebrowser ntfs-3g fastfetch brightnessctl dosfstools neovim p7zip gimp python-pip tldr micro tree most jq diff-so-fancy duf php

# /etc/systemd/logind.conf
HandleLidSwitch=ignore
HandleLidSwitchDocked=ignore
HandleLidSwitchExternalPower=ignore

# /etc/systemd/sleep.conf
AllowSuspend=yes
AllowHibernation=yes
AllowSuspendThenHibernate=no
AllowHybridSleep=no

# /etc/mkinitcpio.conf
MODULES=(ext4 nvme nvme_core)
HOOKS=(base autodetect resume modconf kms)

# /etc/mkinitcpio.d/linux-zen.preset
PRESETS=('default')

su - u
git clone --depth=1 https://aur.archlinux.org/paru-bin.git
cd paru-bin
yes | makepkg -si
cd ..
rm -rf paru-bin

# Essential
paru -S --noconfirm onedrive-abraunegg authy anki-bin google-chrome visual-studio-code-bin spotify-wayland bluetuith postman-bin etcher-bin scc pycharm-community-jre anydesk-bin
exit

exit
umount -R /mnt
reboot

chezmoi init --apply https://github.com/ulissesjdeo/dotfiles.git
