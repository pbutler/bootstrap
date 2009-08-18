#!/bin/bash

if [ ! "x$1" == "x-n" ]; then
	echo "Updating... "
	svn update
fi

cp -f bashrc ~/.bashrc
cp -f ssh_config ~/.ssh/config
cp -f vimrc ~/.vimrc
cp -f screenrc ~/.screenrc
cp -f gitconfig ~/.gitconfig
cp -f vimperatorrc ~/.vimperatorrc

if [ ! -d ~/bin ]; then
	mkdir ~/bin
fi
cp -r bin/* ~/bin
cp -r vim ~/.vim
