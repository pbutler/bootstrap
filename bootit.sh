#!/bin/bash

if [ ! $1 == "-n" ]; then
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
