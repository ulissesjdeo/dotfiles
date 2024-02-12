paru -S --noconfirm waydroid

sudo waydroid init -s GAPPS

sudo systemctl disable waydroid-container

wget https://f-droid.org/F-Droid.apk
waydroid app install F-Droid.apk

# https://docs.waydro.id/faq/google-play-certification
# https://docs.waydro.id/faq/using-adb-with-waydroid
