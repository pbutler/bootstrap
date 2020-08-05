#!/bin/bash


{{- if eq .chezmoi.os "darwin" }}
brew install neovim vim wget node git ripgrep imagemagick \
	mosh coreutils hub mosh htop bluetoothconnector

brew tap homebrew/cask-fonts
# charles easyfind joplin kap
brew cask install adium alfred arq bartender google-chrome firefox \
	font-firacode-nerd-font hammerspoon inkscape iterm2 java \
	karabiner-elements kitty nordvpn mactex nvalt slack spotify \
	pock gpg-suite-no-mail jupyter-notebook-viewer tunnelblick \
	the-unarchiver ultimaker-cura virtualbox virtualbox-extension-pack \
	xquartz
{{- end }}
