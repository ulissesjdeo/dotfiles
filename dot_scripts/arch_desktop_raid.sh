# Both 1 full-sized partition with code FD00 (Linux RAID)
gdisk /dev/sda
gdisk /dev/sdb

mdadm --create --verbose --level=0 --metadata=1.2 --raid-devices=2 /dev/md/raid /dev/sda1 /dev/sda2
cat /proc/mdstat

mdadm --detail --scan >> /etc/mdadm.conf

mkfs.ext4 -v -L raidarray -b 4096 -E stride=128,stripe-width=256 /dev/md127

mount /dev/md127 /mnt

pacstrap -K /mnt base linux linux-firmware


