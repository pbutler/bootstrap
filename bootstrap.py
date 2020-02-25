#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
# vim: ts=4 sts=4 sw=4 tw=88 sta et
"""%prog [options]
Python source code - @todo
"""

__author__ = "Patrick Butler"
__email__ = "pbutler@killertux.org"
__version__ = "0.0.1"

import sys
from bootit2 import BootIt, Path, Brew
from bootit2 import Chmod, Copy, Cmd, Echo, Link, Mkdir, Pip, Sync, Touch

with BootIt():
    Mkdir("~/.cache", mode="0700")
    Mkdir("~/.config", mode="0700")

    Mkdir("~/.ssh", "0700")
    Copy(src="ssh_config", dest="~/.ssh/config")
    Chmod("~/.ssh/config", "0600")

    Link(src="kitty", dest="~/.config/kitty")
    Cmd("echo shell `which xonsh` > ~/.config/kitty/kitty-shell.conf")
    Link(src="xonshrc", dest="~/.xonshrc")
    Link(src="bashrc", dest="~/.bashrc")
    Link(src="tmux.conf", dest="~/.tmux.conf")

    Sync(src="bin", dest="~/bin", clean=False)
    Link(src="gitconfig", dest="~/.gitconfig")

    Link(src="nvim", dest="~/.config/nvim")
    Link(src="vimrc", dest="~/.vimrc")
    Link(src="vim", dest="~/.vim")
    Mkdir("~/.cache/vim/tmp", "0700")
    Mkdir("~/.cache/vim/backup", "0700")
    Mkdir("~/.cache/vim/undos", "0700")

    Pip(pkgs=["pip", "glances"], user=True, upgrade=True)

    xonsh_opts = ["ptk", "pygments", "proctitle"]
    if sys.platform == "darwin":
        xonsh_opts += ["mac"]
    elif sys.platform == "linux":
        xonsh_opts += ["linux"]
    xonsh_opts = ",".join(xonsh_opts)

    Pip(pkgs=["xonsh[{}]".format(xonsh_opts),
              "xontrib-readable-traceback", "xontrib-ssh-agent", "xontrib-kitty",
              "xontrib-readable-traceback", "xontrib-ssh-agent"],
        user=True,
        upgrade=False)

    if sys.platform == "darwin":
        Echo("OS X detected installing applicable files...")
        if not Path("~/.osx_ran").expanduser().exists():
            Cmd("./osx.sh")
            Touch("~/.osx_ran")
        else:
            Echo("Skipping osx configs, already ran")

        logo_url = ("https://www.freepnglogos.com/uploads/spotify-logo-png"
                    "/spotify-icon-marilyn-scott-0.png")

        Cmd("curl -L {} > ~/.cache/spotify.png".format(logo_url))  # NOQA

        Copy(src="fonts/Droid Sans Mono Slashed for Powerline.ttf",
             dest="~/Library/Fonts/Droid Sans Mono Slashed for Powerline.ttf")

        Brew(pkgs=["neovim", "vim", "wget", "node", "git", "ripgrep", "imagemagick",
                   "hub", "mosh", "htop", "bluetoothconnector"])

        # little-snitch charles easyfind joplin
        Brew(pkgs=["adium", "alfred", "arq", "bartender", "google-chrome", "firefox",
                   "hammerspoon",
                   "inkscape", "iterm2", "java", "kitty", "mactex",
                   "minikube", "nordvpn", "nvalt", "slack", "spotify",
                   "karabiner-elements",
                   # kap
                   # hazel
                   "pock", "gpg-suite-no-mail", "jupyter-notebook-viewer",
                   # "spotify-notifications",
                   "the-unarchiver", "ultimaker-cura",
                   "virtualbox", "virtualbox-extension-pack", "xquartz"],
             cask=True)
