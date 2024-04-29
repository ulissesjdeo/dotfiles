cd $HOME

rm -rf .zsh
mkdir .zsh
cd .zsh

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git powerlevel10k
git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search.git history_substring_search
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git syntax_highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git autosuggestions
