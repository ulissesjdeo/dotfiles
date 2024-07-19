pkg install eza bat zsh build-essential dart golang nodejs php python rust ffmpeg radare2 vim neovim dcraw imagemagick openjpeg-tools optipng
rm music movies podcasts documents audiobooks media-0 external-0 shared dcim downloads pictures
rmdir storage
ln -s /storage/emulated/0/ storage
sh .config/scripts/zsh.sh
