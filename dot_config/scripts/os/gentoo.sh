net-setup

gdisk /dev/nvme0nX
# 512 MB - EFI (ef00)
# 8 GB - SWAP (8200)
# Free space - Root (8304)

mkfs.fat -F 32 /dev/nvme0nXp1
mkswap /dev/nvme0nXp2
mkfs.f2fs /dev/nvme0nXp3

swapon /dev/nvme0nXp2
mount /dev/nvme0nXp3 /mnt/gentoo
cd /mnt/gentoo

wget https://mirrors.rit.edu/gentoo/releases/amd64/autobuilds/current-stage3-amd64-nomultilib-openrc/stage3-amd64-nomultilib-openrc-20240128T165521Z.tar.xz
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner && rm stage*xz

emerge -a app-portage/cpuid2cpuflags

# etc/portage/make.conf
COMMON_FLAGS="-march=alderlake -O2 -pipe"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"
MAKEOPTS="-j4"
USE="-kde -qt5 -gnome -gtk -dvd -cdr -systemd"
ACCEPT_LICENSE="*"
L10N="en en-US"
VIDEO_CARDS="intel"
GRUB_PLATFORMS="efi-64"

echo "*/* $(cpuid2cpuflags)" > etc/portage/package.use/00cpu-flags

mirrorselect -i -o >> etc/portage/make.conf

mkdir -p etc/portage/repos.conf
cp usr/share/portage/config/repos.conf etc/portage/repos.conf/gentoo.conf
cp --dereference /etc/resolv.conf etc/

arch-chroot /mnt/gentoo

source /etc/profile
export PS1="(chroot) ${PS1}"

mkdir /efi
mount /dev/nvme0nXp1 /efi

emerge-webrsync && emerge --sync -q

eselect profile list
eselect profile set $X

emerge -avuDN @world

echo "America/Sao_Paulo" > etc/timezone

emerge --config sys-libs/timezone-data

echo "en_US.UTF-8 UTF-8" > etc/locale.gen && locale-gen

eselect locale list
eselect locale set $X

env-update && source etc/profile && export PS1="(chroot) ${PS1}"

emerge -aq sys-kernel/linux-firmware # sys-firmware/sof-firmware

# Manual kernel customization steps
emerge -aq sys-kernel/gentoo-sources sys-apps/pciutils
eselect kernel list
eselect kernel set $X
cd /usr/src/linux
make menuconfig
# Enable necessary as https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Kernel#Enabling_required_options
make -j4 && make modules_install
make install

# etc/fstab
/dev/nvme0nXp1 /efi vfat defaults,noatime 0 2
/dev/nvme0nXp2 none swap sw 0 0
/dev/nvme0nXp1 / f2fs defaults 0 1

nano etc/issue # Remove .\O

echo 'note' > etc/hostname

emerge -aq net-misc/dhcpcd net-wireless/iwd

rc-update add dhcpcd
rc-update add iwd default

nano etc/hosts
nano etc/conf.d/keymaps
nano etc/conf.d/hwclock

visudo
useradd -m -G audio,usb,video,wheel,users,portage,disk -s /bin/bash u
passwd u
passwd

emerge -aq sys-fs/f2fs-tools sys-boot/grub

grub-install --target=x86_64-efi --efi-directory=/efi --removable
grub-mkconfig -o /efi/grub/grub.cfg

exit

umount -l /mnt/gentoo/dev{/shm,/pts,} && cd && umount -R /mnt/gentoo
reboot