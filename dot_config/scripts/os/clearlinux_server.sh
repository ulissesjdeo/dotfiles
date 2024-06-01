sudo su
swupd bundle-add openssh-server
systemctl edit sshd.socket

# sshd.socket
[Socket]
ListenStream=
ListenStream=22

systemctl daemon-reload
systemctl restart sshd.socket
systemctl mask clr-power.timer
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
swupd bundle-add cronie tmux wget
systemctl enable --now cronie
systemctl mask tallow.service
systemctl mask pacdiscovery.path
systemctl mask pacdiscovery.service
systemctl mask networkd-fallback.timer
systemctl mask systemd-journald.socket
systemctl mask systemd-journald.service
systemctl mask systemd-timesyncd.service
systemctl mask serial-getty@ttyS0.service
systemctl mask systemd-journald-dev-log.socket
usermod -s /bin/sh root
echo u > /etc/cron.allow
mkdir /etc/kernel/cmdline.d/ -p

# /etc/kernel/cmdline.d/boot.conf
quiet nowatchdog nmi_watchdog=0 mitigations=off loglevel=0 rd.udev.log_level=0 \
intel_idle.max_cstate=1 cryptomgr.notests initcall_debug intel_iommu=igfx_off \
no_timer_check noreplace-smp page_alloc.shuffle=1 rcupdate.rcu_expedited=1 tsc=reliable

# /usr/lib/systemd/system/var-swapfile.swap
Options=discard,fixpgsz,nofail

swapoff -a
rm /var/swapfile
clr-boot-manager update
