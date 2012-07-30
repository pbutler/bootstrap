#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# vim: ts=4 sts=4 sw=4 tw=79 sta et
"""%prog [options]
Python source code - @todo
"""

__author__ = 'Patrick Butler'
__email__ = 'pbutler@killertux.org'

from subprocess import call
from urllib import urlopen
import tempfile
import os
import site


def ez_setup(user=False):
    f = tempfile.NamedTemporaryFile(delete=False)
    fname = f.name
    data = urlopen("http://peak.telecommunity.com/dist/ez_setup.py").read()
    f.write(data)
    f.close()
    cmd = ["python", fname]
    if user:
        udir = user[:user.find("lib")]
        cmd += ["--prefix=" + udir]
    print cmd
    cmd += ["setuptools"]
    call(cmd)


def install_pip(user=False):
    cmd = "easy_install"
    if user:
        cmd = os.path.join(os.environ['HOME'], ".local", "bin", cmd)
        extra_args = ["--user"]
    else:
        extra_args = []
        cmd = "easy_install"
    call(cmd + extra_args)


def install_pkgs(user=False):
    cmd = "pip"
    packages = ["virtualenv", "BeautifulSoup4", "Requests"]
    if user:
        cmd = os.path.join(os.environ['HOME'], ".local", "bin", cmd)
        extra_args = ["--user"]
    else:
        extra_args = []
    for p in packages:
        call(cmd + ["install", p] + extra_args)

def main(args):
    import  optparse
    parser = optparse.OptionParser()
    parser.usage = __doc__
    parser.add_option("-q", "--quiet",
                      action="store_false", dest="verbose", default=True,
                      help="don't print status messages to stdout")
    (options, args) = parser.parse_args()
    if len(args) < 0:
        parser.error("Not enough arguments given")
    usdir = site.getusersitepackages()
    if not os.path.exists(usdir):
        os.makedirs(usdir)

    ez_setup(usdir)
    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main(sys.argv))

