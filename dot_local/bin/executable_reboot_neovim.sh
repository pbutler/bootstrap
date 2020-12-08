#!/bin/bash

set -e

rm -rf ~/.cache/dein ~/.virtualenvs/neovim-py2 ~/.virtualenvs/neovim-py3

tmpfile=$(mktemp)
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > $tmpfile
sh $tmpfile ~/.cache/dein
# yeah could leak in a crash but it's not a big deal, it's one file rarely run
rm -f $tmpfile

python3 -mvenv ~/.virtualenvs/neovim-py3
. ~/.virtualenvs/neovim-py3/bin/activate
pip install --upgrade pip
pip install --upgrade neovim
deactivate

# virtualenv -ppython2.7 ~/.virtualenvs/neovim-py2
# . ~/.virtualenvs/neovim-py2/bin/activate
# pip install --upgrade pip neovim
# deactivate
