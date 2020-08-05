#!/bin/bash

rm -rf ~/venv/neovim-py3
virtualenv -p python3 ~/venv/neovim-py3
.  ~/venv/neovim-py3/bin/activate
pip install neovim
deactivate

rm -rf ~/venv/neovim-py2
virtualenv -p python2 ~/venv/neovim-py2
.  ~/venv/neovim-py2/bin/activate
pip install neovim
deactivate
