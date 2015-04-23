#!/bin/bash

if ! dpkg -l | grep ncurses-term > /dev/null
then
	sudo apt-get install ncurses-term
fi

if [ ! -h ~/.vimrc ]
then
	ln -s dotfiles/vimrc ../.vimrc
	ln -s dotfiles/tmux ../.tmux.conf
fi

if ! grep 'alias tmux' ~/.bashrc -q
then
	echo "alias tmux='tmux -2'" >> ~/.bashrc
fi
