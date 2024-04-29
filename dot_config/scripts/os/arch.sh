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

pacstrap -K /mnt intel-ucode sof-firmware base linux linux-firmware nano sudo

# /mnt/etc/mkinitcpio.conf
MODULES=(nvme_core nvme f2fs)
HOOKS=(base resume autodetect microcode modconf kms)

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
n

# /etc/pacman.conf
ParallelDownloads = 3

[multilib]
Include = /etc/pacman.d/mirrorlist

# /etc/sudoers
%wheel ALL=(ALL:ALL) NOPASSWD: ALL

useradd -mG wheel u
usermod -s /bin/sh root
passwd u
passwd

pacman -S networkmanager irqbalance bluez ly
systemctl enable NetworkManager
systemctl enable irqbalance
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
options root=/dev/nvme0nXp3 resume=/dev/nvme0nXp2 rw quiet nmi_watchdog=0 mitigations=off \
    systemd.show_status=false rd.udev.log_level=0 vt.global_cursor_default=0 i915.fastboot=1

pacman -S \
    plasma-desktop plasma-nm plasma-pa bluedevil git zip \
    power-profiles-daemon kscreen kcalc konsole dolphin zsh \
    spectacle chezmoi discord telegram-desktop p7zip wine \
    ntfs-3g neovim bitwarden flatpak base-devel unzip openssh \
    gwenview okular gimp kdenlive krita blender podman podman-docker \
    obs-studio obsidian

# /etc/systemd/sleep.conf
AllowSuspend=yes
AllowHibernation=yes
AllowSuspendThenHibernate=no
AllowHybridSleep=no

su - u
git clone --depth=1 https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si
cd ..
rm -rf paru-bin

# Essential
paru -S --noconfirm \
    onedrive-abraunegg anki-bin google-chrome snapd zapzap \
    visual-studio-code-bin spotify thorium-browser-bin \
    prismlauncher-qt5-bin aur-auto-vote-git tor-browser-bin \
    todoist-appimage mkinitcpio-firmware
exit

exit
umount -R /mnt
reboot



# Post-install setup



# Files and configs
onedrive --synchronize
chezmoi init --apply git@github.com:ulissesjdeo/dotfiles.git
sudo usermod -s /bin/zsh u
ln -s $HOME/OneDrive/Desktop Desktop
ln -s $HOME/OneDrive/Docs Documents



# ALHP
paru -S --noconfirm alhp-keyring alhp-mirrorlist

# /etc/pacman.conf
[core-x86-64-v3]
Include = /etc/pacman.d/alhp-mirrorlist

[extra-x86-64-v3]
Include = /etc/pacman.d/alhp-mirrorlist

[multilib-x86-64-v3]
Include = /etc/pacman.d/alhp-mirrorlist

paru -Syu



# Steam
paru -S steam-native-runtime

