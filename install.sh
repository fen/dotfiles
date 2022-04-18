#!/bin/sh

cd $HOME

# No thank you
rm -rf .oh-my-bash
rm -rf .oh-my-zsh
rm .zshrc

# A bit of a hack
mv .gitconfig .gitconfig.private

git clone https://github.com/dcreager/dotfiles-base .dotfiles.base
git clone https://github.com/dcreager/dotfiles-public -b codespaces --recurse-submodules .dotfiles.public
$HOME/.dotfiles.base/bin/dotfiles.symlink install

# I'd like to use fish, please
apt-get install -y fish
chsh -s /usr/bin/fish

# Install fzf
curl -L https://github.com/junegunn/fzf/releases/download/0.30.0/fzf-0.30.0-linux_amd64.tar.gz | tar xzC $HOME/bin

# Install neovim
apt-get install -y libfuse2
curl -L -o $HOME/bin/nvim https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod a+x $HOME/bin/nvim
