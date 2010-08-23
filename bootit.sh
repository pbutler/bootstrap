#!/bin/bash

if [ ! "x$1" == "x-n" ]; then
	echo "Updating... "
	svn update
fi

echo "Copying..."

if [ ! -d ~/.ssh ]; then
	mkdir -p -m 0700 ~/.ssh
fi

cp -f bashrc ~/.bashrc
cp -f ssh_config ~/.ssh/config
cp -f vimrc ~/.vimrc
cp -f screenrc ~/.screenrc
cp -f gitconfig ~/.gitconfig
cp -f vimperatorrc ~/.vimperatorrc
cp -f Xdefaults ~/.Xdefaults

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

if [ -x `which svn` ]; then
	svn --force export vim/ ~/.vim
else
	cp -r vim/* ~/.vim
	find ~/.vim -type d -name .svn -exec rm -rf "{}" \;
fi

if [ `uname -s` = "Darwin" ]; then
	echo "OS X detected installing applicable files..."
	if [ -x ~/.cabal/bin/xmonad ]; then
		echo "Installing Xmonad config..."
		cp -f osx/Xmodmap ~/.Xmodmap
		cp -f osx/xinitrc ~/.xinitrc
		mkdir -p ~/.xmonad
		cp osx/xmonad.hs ~/.xmonad/xmonad.hs
	fi
fi
