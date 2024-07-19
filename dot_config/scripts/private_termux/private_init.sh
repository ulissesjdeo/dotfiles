pkg install openssh chezmoi git
termux-setup-storage
whoami
passwd
sshd
eval $(ssh-agent -s)
ssh-add storage/downloads/Telegram/ud_ed25519
chezmoi init --apply git@github.com:ulissesjdeo/dotfiles.git
