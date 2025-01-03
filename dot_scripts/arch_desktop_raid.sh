gdisk /dev/sda
# 256 MB - EFI system partition (EF00)
# ALL - Linux RAID (FD00)

gdisk /dev/sdb
# 256 MB - Free space
# ALL - Linux RAID (FD00)

mdadm --create --verbose --level=0 --metadata=1.2 --raid-devices=2 /dev/md/raid /dev/sda1 /dev/sda2
cat /proc/mdstat

mkfs.fat -F 32 /dev/sda1
mkfs.ext4 -v -L raidarray -b 4096 -E stride=128,stripe-width=256 /dev/md127

mount /dev/md127 /mnt
mount /dev/sda1 /mnt/boot --mkdir

pacstrap -K /mnt \
    base-devel linux linux-lts linux-firmware mdadm neovim sudo amd-ucode \
    plasma-desktop plasma-pa plasma-nm dolphin konsole kscreen bluedevil \
    firefox openssh chezmoi git networkmanager bluez ly

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable ly

genfstab -U /mnt >> /mnt/etc/fstab
mdadm --detail --scan >> /mnt/etc/mdadm.conf

# /etc/mkinitcpio.conf
MODULES=(nvme nvme_core ext4)
HOOKS=(base udev autodetect microcode modconf kms mdadm_udev)

# /mnt/etc/mkinitcpio.d/linux.preset
PRESETS=('default')

# /mnt/etc/mkinitcpio.d/linux-lts.preset
PRESETS=('default')

arch-chroot /mnt

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc

# /etc/pacman.conf
ParallelDownloads = 3

# /etc/locale.conf
LANG=en_US.UTF-8

# /etc/hostname
d

# /etc/locale.gen
en_US.UTF-8 UTF-8

locale-gen

# /etc/sudoers
%wheel ALL=(ALL:ALL) NOPASSWD: ALL

usermod -s /bin/sh root
passwd -d root
useradd -mG wheel u
passwd u

bootctl install

# /boot/loader/loader.conf
default arch.conf
timeout 3
console-mode keep
editor no

# /boot/loader/entries/arch.conf
title Arch Linux
linux /vmlinuz-linux
initrd /amd-ucode.img
initrd /initramfs-linux.img
options \
    root=/dev/md/raid rw quiet nmi_watchdog=0 mitigations=off systemd.show_status=false \
    rd.udev.log_level=0 vt.global_cursor_default=0 raid0.default_layout=2

# /boot/loader/entries/arch-fallback.conf
title Arch Linux LTS (Fallback)
linux /vmlinuz-linux-lts
initrd /amd-ucode.img
initrd /initramfs-linux-lts.img
options root=/dev/md/raid rw raid0.default_layout=2

su - u
git clone --depth=1 https://aur.archlinux.org/aura.git
cd aura
makepkg -si
cd ..
rm -rf aura
exit

exit
umount -R /mnt
reboot

chezmoi init --apply git@github.com:ulissesjdeo/dotfiles.git
