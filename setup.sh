#!/bin/bash

if ! dpkg -l | grep ncurses-term > /dev/null
then
	sudo apt-get install ncurses-term
	# install zeal
	sudo add-apt-repository ppa:zeal-developers/ppa
	sudo apt-get update
	sudo apt-get install zeal
fi

if ! dpkg -l | grep exuberant-ctags > /dev/null
then
	sudo apt-get install exuberant-ctags
fi

if [ ! -h ~/.vimrc ]
then
	ln -s ../dotfiles/vimrc ../.vimrc
	ln -s ../dotfiles/tmux ../.tmux.conf
fi

if ! grep 'alias tmux' ~/.bashrc -q
then
	echo "alias tmux='tmux -2'" >> ~/.bashrc
	echo "alias tmux='tmux -2'" >> ~/.zshrc
fi
