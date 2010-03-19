#!/bin/bash

if [ ! "x$1" == "x-n" ]; then
	echo "Updating... "
	svn update
fi

echo "Copying..."

cp -f bashrc ~/.bashrc
cp -f ssh_config ~/.ssh/config
cp -f vimrc ~/.vimrc
cp -f screenrc ~/.screenrc
cp -f gitconfig ~/.gitconfig
cp -f vimperatorrc ~/.vimperatorrc

chmod 0600 ~/.ssh/config

if [ ! -d ~/.terminfo ]; then
	mkdir -p ~/.terminfo/78
fi
cp -f xterm-256color ~/.terminfo/78/xterm-256color

if [ ! -d ~/bin ]; then
	mkdir ~/bin
fi
cp -r bin/* ~/bin
if [ ! -d ~/.vim ]; then
	mkdir ~/.vim
fi
cp -r vim/* ~/.vim
find ~/.vim -type d -name .svn -exec rm -rf \{\} \;

