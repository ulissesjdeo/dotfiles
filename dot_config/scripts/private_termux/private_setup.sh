pkg install eza bat zsh build-essential dart golang nodejs php python rust rustc-dev ffmpeg radare2 vim neovim dcraw imagemagick openjpeg-tools optipng ripgrep-all p7zip sqlite wget which xz-utils busybox binutils
rm music movies podcasts documents audiobooks media-0 external-0 shared dcim downloads pictures
rmdir storage
ln -s /storage/emulated/0/ storage
sh .config/scripts/zsh.sh
npm install -g pnpm typescript
