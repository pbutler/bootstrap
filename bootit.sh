#!/bin/bash

if [ ! "x$1" == "x-n" ]; then
	echo "Updating... "
	svn update
fi

echo "Copying..."

if [ ! -d ~/.ssh ]; then
	mkdir -p -m 0700 ~/.ssh
fi

cp -f -p bashrc ~/.bashrc
cp -f -p ssh_config ~/.ssh/config
cp -f -p vimrc ~/.vimrc
cp -f -p screenrc ~/.screenrc
cp -f -p gitconfig ~/.gitconfig
rm -f ~/.vimperatorrc
cp -f -p pentadactylrc ~/.pentadactylrc
cp -f -p Xdefaults ~/.Xdefaults

chmod 0600 ~/.ssh/config

if [ ! -d ~/.terminfo ]; then
	mkdir -p ~/.terminfo/78
fi
cp -f xterm-256color ~/.terminfo/78/xterm-256color

if [ ! -d ~/bin ]; then
	mkdir ~/bin
fi

cp -r -p bin/* ~/bin

if [ ! -d ~/.vim ]; then
	mkdir ~/.vim
fi

if [ ! -d ~/.vim/tmp ]; then
	mkdir -p ~/.vim/tmp
	chmod 700 ~/.vim/tmp
fi

if [ -x `which svn` ]; then
	svn --force export vim/ ~/.vim
else
	cp -p -r vim/* ~/.vim
	find ~/.vim -type d -name .svn -exec rm -rf "{}" \;
fi

if [ `uname -s` = "Darwin" ]; then
	echo "OS X detected installing applicable files..."
	if [ -x ~/.cabal/bin/xmonad ]; then
		echo "Installing Xmonad config..."
		cp -f -p osx/Xmodmap ~/.Xmodmap
		cp -f -p osx/xinitrc ~/.xinitrc
		mkdir -p ~/.xmonad
		cp -p osx/xmonad.hs ~/.xmonad/xmonad.hs
	fi
fi
