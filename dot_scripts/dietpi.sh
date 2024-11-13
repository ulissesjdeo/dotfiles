# Write initial config most minimalistic way possible

nano /etc/motd
touch .hushlogin

systemctl mask --now systemd-journald
systemctl mask --now systemd-journald.socket
systemctl mask --now systemd-journald-audit.socket
systemctl mask --now systemd-journald-dev-log.socket
