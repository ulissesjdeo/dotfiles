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

pacstrap -K /mnt sof-firmware intel-ucode base linux linux-firmware nano sudo

# /mnt/etc/mkinitcpio.conf
MODULES=(nvme nvme_core f2fs)
HOOKS=(base resume autodetect microcode modconf kms)

# /mnt/etc/mkinitcpio.d/linux.preset
PRESETS=('default')

genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

pacman -S tmux syncthing chezmoi git

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

pacman -S networkmanager bluez ly
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable ly

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
    rd.udev.log_level=0 vt.global_cursor_default=0 i915.fastboot=1

# /etc/systemd/sleep.conf
AllowSuspend=yes
AllowHibernation=yes
AllowSuspendThenHibernate=no
AllowHybridSleep=no

pacman -S plasma-desktop dolphin konsole kscreen plasma-nm bluedevil power-profile-daemon plasma-pa gdisk dosfstools base-devel

exit
umount -R /mnt
reboot

git clone --depth=1 https://aur.archlinux.org/aura.git
cd aura
makepkg -si
cd ..
rm -rf aura

aura -A flutter-bin android-studio

chezmoi init --apply git@github.com:ulissesjdeo/dotfiles.git
