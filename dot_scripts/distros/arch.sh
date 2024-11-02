setfont ter-132b
iwctl station wlan0 connect $SSID

gdisk /dev/nvme0nX

mkfs.fat -F 32 /dev/nvme0nXp1
mkswap /dev/nvme0nXp2
mkfs.f2fs /dev/nvme0nXp3

mount /dev/nvme0nXp3 /mnt
mount /dev/nvme0nXp1 /mnt/boot --mkdir
swapon /dev/nvme0nXp2

# /etc/pacman.conf
ParallelDownloads = 3

pacstrap -K /mnt intel-ucode base linux linux-firmware nano sudo

# /mnt/etc/mkinitcpio.conf
MODULES=(nvme nvme_core f2fs)
HOOKS=(base resume autodetect microcode modconf kms)

# /mnt/etc/mkinitcpio.d/linux.preset
PRESETS=('default')

genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

pacman -S vi nano tmux syncthing chezmoi openssh git

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc

# /etc/pacman.conf
ParallelDownloads = 3

# /etc/locale.conf
LANG=en_US.UTF-8

# /etc/hostname
n

# /etc/locale.gen
en_US.UTF-8 UTF-8

locale-gen

# /etc/sudoers
%wheel ALL=(ALL:ALL) NOPASSWD: ALL

usermod -s /bin/sh root
passwd -d root
useradd -mG wheel u
passwd u

pacman -S dropbear dhcpcd cronie iwd
systemctl enable dropbear
systemctl enable dhcpcd
systemctl enable cronie
systemctl enable iwd

bootctl install

# /boot/loader/loader.conf
default arch.conf
timeout 0
console-mode keep
editor no

# /boot/loader/entries/arch.conf
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options \
    root=/dev/nvme0nXp3 resume=/dev/nvme0nXp2
    rw quiet nmi_watchdog=0 mitigations=off systemd.show_status=false \
    rd.udev.log_level=0 vt.global_cursor_default=0 i915.fastboot=1 consoleblank=15

# /etc/systemd/sleep.conf
AllowSuspend=yes
AllowHibernation=yes
AllowSuspendThenHibernate=no
AllowHybridSleep=no

# /etc/systemd/logind.conf
HandlePowerKeyLongPress=ignore
HandleRebootKey=ignore
HandleRebootKeyLongPress=ignore
HandleSuspendKey=ignore
HandleSuspendKeyLongPress=ignore
HandleHibernateKey=ignore
HandleHibernateKeyLongPress=ignore
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore

exit
umount -R /mnt
reboot

chezmoi init --apply git@github.com:ulissesjdeo/dotfiles.git
