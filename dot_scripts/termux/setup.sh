# Install packages
pkg install eza bat zsh build-essential dart golang nodejs php python rust rustc-dev ffmpeg radare2 vim neovim dcraw imagemagick openjpeg-tools optipng ripgrep-all p7zip sqlite wget which xz-utils busybox binutils ldd zip unzip

# Storage setup
cd storage
rm music movies podcasts documents audiobooks media-0 external-0 shared dcim downloads pictures
rmdir storage

# Add folders reference
ln -s /storage/emulated/0/ storage
ln -s /storage/emulated/0/DCIM/ DCIM
ln -s /storage/emulated/0/Files/ Files

# Install node packages
npm install -g pnpm typescript
