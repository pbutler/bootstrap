#!/bin/bash

set -e

rm -rf ~/.cache/dein ~/.virtualenvs/neovim-py2 ~/.virtualenvs/neovim-py3

./install-dein.sh ~/.cache/dein

python3 -mvenv ~/.virtualenvs/neovim-py3
. ~/.virtualenvs/neovim-py3/bin/activate
pip install --upgrade pip
pip install --upgrade neovim
deactivate

virtualenv -ppython2.7 ~/.virtualenvs/neovim-py2
. ~/.virtualenvs/neovim-py2/bin/activate
pip install --upgrade pip neovim
deactivate
