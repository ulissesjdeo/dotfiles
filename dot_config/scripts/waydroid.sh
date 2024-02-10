paru -S --noconfirm waydroid

sudo waydroid init -s GAPPS

sudo systemctl disable --now waydroid-container

sudo systemctl start waydroid-container

wget https://f-droid.org/F-Droid.apk

waydroid app install F-Droid.apk

sudo mount --bind ~/Documents ~/.local/share/waydroid/data/media/0/Documents
sudo mount --bind ~/Downloads ~/.local/share/waydroid/data/media/0/Download

# https://docs.waydro.id/faq/google-play-certification
# https://docs.waydro.id/faq/using-adb-with-waydroid
